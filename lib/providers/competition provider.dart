import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/models/competition/competition%20comment%20model.dart';
import 'package:news/network/cash_helper.dart';
import 'package:news/shared/Components.dart';

import '../models/competition/competition model.dart';
import '../models/competition/competitor model.dart';

class CompetitionProvider with ChangeNotifier {
  bool isLoading = false;
  File? pickedImageCountry;
  File? pickedCompetitorImage;
  final picker = ImagePicker();
  String dateAfterEdit = '';
  List<CompetitionModel> competitions = [];
  List<CompetitorModel> competitors = [];
  List<CompetitionCommentModel> comments = [];
  double score = 0.0;

  Future<void> getCompetitions() async {
    competitions = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse('http://iffsma-2030.com/public/api/v1/competitions');
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    Map<String, dynamic> data = json.decode(response.body);
    List allCompetitions = data['data'];
    if (response.statusCode == 200) {
      for (var element in allCompetitions) {
        competitions.add(CompetitionModel.fromJSON(element));
      }
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> getAllCompetitors(int competitionID) async {
    competitors = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'http://iffsma-2030.com/public/api/v1/contestants?competition_id=$competitionID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    List allCompetitions = data['data'];
    if (response.statusCode == 200) {
      for (var element in allCompetitions) {
        competitors.add(CompetitorModel.fromJSON(element));
      }
      competitors.sort((a, b) {
        double aScore = double.parse(a.score);
        double bScore = double.parse(b.score);
        return bScore.compareTo(aScore);
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> addComment(
      int competitionID, int competitorID, String comment) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var userID = CacheHelper.getData(key: 'id') ?? '';
    var url =
        Uri.parse('http://iffsma-2030.com/public/api/v1/user/add/comment');
    Map<String, dynamic> competitionCommentModel = {
      'user_id': userID.toString(),
      'competition_id': competitionID.toString(),
      'contestant_id': competitorID.toString(),
      'comment': comment,
    };
    var body1 = jsonEncode(competitionCommentModel);
    var body2 = jsonDecode(body1);
    var response = await http.post(
      url,
      body: body2,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      showToast(text: 'تم التعليق بنجاح', state: ToastStates.SUCCESS);
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> getComments(int competitorID) async {
    comments = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'http://iffsma-2030.com/public/api/v1/contestant/comments?contestant_id=$competitorID');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    var commentList = data['data'];
    if (response.statusCode == 200) {
      commentList.forEach((element) {
        comments.add(CompetitionCommentModel.fromJSON(element));
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  Future<void> addVote(int competitionID, int competitorID) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var userID = CacheHelper.getData(key: 'id') ?? '';
    var url = Uri.parse('http://iffsma-2030.com/public/api/v1/user/add/vote');
    Map<String, dynamic> data = {
      'user_id': userID.toString(),
      'competition_id': competitionID.toString(),
      'contestant_id': competitorID.toString(),
    };
    var response = await http.post(
      url,
      body: data,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200 && getData['status'] == true) {
      showToast(text: 'تم التصويت بنجاح', state: ToastStates.SUCCESS);
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void selectCountryImage() async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    pickedImageCountry = File(pickedImageFile!.path);
    notifyListeners();
    if (pickedImageCountry != null) {
      showToast(
          text: 'تم اختيار صورة الدولة بنجاح', state: ToastStates.SUCCESS);
    }
  }

  void selectCompetitorImage() async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    pickedCompetitorImage = File(pickedImageFile!.path);
    notifyListeners();
    if (pickedCompetitorImage != null) {
      showToast(
          text: 'تم اختيار صورة المتسابق بنجاح', state: ToastStates.SUCCESS);
    }
  }

  void shareInCompetition(
    String competitionID,
    String nameCompetitor,
    String position,
    String videoLink,
  ) async {
    if (pickedImageCountry == null) {
      showToast(text: 'يجب اختيار صورة الدولة', state: ToastStates.ERROR);
    } else if (pickedCompetitorImage == null) {
      showToast(text: 'يجب اختيار صورة المتسابق', state: ToastStates.ERROR);
    } else {
      isLoading = true;
      notifyListeners();
      showToast(text: 'جارى رفع الصور و الفيديو', state: ToastStates.WARNING);
      String token = CacheHelper.getData(key: 'token') ?? '';
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://iffsma-2030.com/public/api/v1/user/Participate'));
      request.fields.addAll({
        'name': nameCompetitor,
        'center': position,
        'video_link': videoLink,
        'competition_id': competitionID
      });
      request.files.add(await http.MultipartFile.fromPath(
          'image', pickedCompetitorImage!.path));
      request.files.add(await http.MultipartFile.fromPath(
          'country_image', pickedImageCountry!.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final decodedData = json.decode(data);
      if (response.statusCode == 200) {
        isLoading = false;
        pickedImageCountry = null;
        pickedCompetitorImage = null;
        showToast(
            text: 'انتظر حتى يتم قبولك بالمسابقة', state: ToastStates.SUCCESS);
        notifyListeners();
      } else {
        isLoading = false;
        pickedImageCountry = null;
        pickedCompetitorImage = null;
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        notifyListeners();
      }
    }
  }

  void updateDate(String date) {
    if (date.contains('Jan')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '1,');
    } else if (date.contains('Feb')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('F'), date.indexOf('F') + 3, '2,');
    } else if (date.contains('Mar')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('M'), date.indexOf('M') + 3, '3,');
    } else if (date.contains('Apr')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('A'), date.indexOf('A') + 3, '4,');
    } else if (date.contains('May')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('M'), date.indexOf('M') + 3, '5,');
    } else if (date.contains('Jun')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '6,');
    } else if (date.contains('Jul')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '7,');
    } else if (date.contains('Aug')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('A'), date.indexOf('A') + 3, '8,');
    } else if (date.contains('Sep')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('S'), date.indexOf('S') + 3, '9,');
    } else if (date.contains('Oct')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('O'), date.indexOf('O') + 3, '10,');
    } else if (date.contains('Nov')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('N'), date.indexOf('N') + 3, '11,');
    } else if (date.contains('Dec')) {
      dateAfterEdit =
          date.replaceRange(date.indexOf('D'), date.indexOf('D') + 3, '12,');
    }
  }

  void getGoldenMedal() {
    score = 0.0;
    score = double.parse(competitors[0].score);
    notifyListeners();
  }
}
