import 'dart:convert';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/models/sport%20services/sport%20services%20categories.dart';
import 'package:http/http.dart' as http;
import 'package:news/network/cash_helper.dart';
import '../models/sport services/sport services comments.dart';
import '../models/sport services/sport services news.dart';
import '../shared/Components.dart';
import 'dart:developer';

class SportServicesProvider with ChangeNotifier {
  bool isLoading = false;
  List<SportServicesCategoriesModel> sportServicesCategoriesModel = [];
  List<SportServicesNewsModel> sportServicesNewsModel = [];
  var picker = ImagePicker();
  List<File> pickedImage = [];
  File? pickedImagePublish;
  List<SportServicesCommentsModel> comments = [];
  TextEditingController search = TextEditingController();

  void searchAboutNews() {
    List<SportServicesNewsModel> news = [];
    news = sportServicesNewsModel.where((element) {
      var searchItem = element.title.toLowerCase();
      return searchItem.contains(search.text.toLowerCase());
    }).toList();
    sportServicesNewsModel = [];
    sportServicesNewsModel = news;
    notifyListeners();
  }

  void pickImagesNews() async {
    pickedImage = [];
    await picker.pickMultiImage().then((value) {
      if (value.length <= 6) {
        for (var element in value) {
          pickedImage.add(File(element.path));
        }
        notifyListeners();
      } else {
        pickedImage = [];
        notifyListeners();
      }
    });
    if (pickedImage.isNotEmpty) {
      showToast(text: 'تم إختيار الصور', state: ToastStates.SUCCESS);
    } else {
      showToast(
          text: 'يجب اختيار عدد من الصور أقل من 6', state: ToastStates.ERROR);
    }
  }

  void pickImagePublisher() async {
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      pickedImagePublish = File(value!.path);
      notifyListeners();
    });
  }

  void getSportServicesCategories() async {
    sportServicesCategoriesModel = [];
    isLoading = true;
    var url = Uri.parse(
        'http://iffsma-2030.com/public/api/v1/sport_service_categories');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'].forEach((element) {
        sportServicesCategoriesModel
            .add(SportServicesCategoriesModel.fromJSON(element));
      });
      isLoading = false;
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSportServicesNews(String id) async {
    sportServicesNewsModel = [];
    var url = Uri.parse(
        'http://iffsma-2030.com/public/api/v1/sport_service_categories/$id');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      getData['data'].forEach((element) {
        sportServicesNewsModel.add(SportServicesNewsModel.fromJson(element));
      });
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> addNews(
    String title,
    String description,
    String link,
    String categoryID,
    String tellAboutYourSelf,
    String publisherName,
    String publisherCountry,
  ) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    if (pickedImage.isEmpty) {
      showToast(
          text: 'يجب اختيار عدد من الصور أقل من 6', state: ToastStates.ERROR);
    } else {
      isLoading = true;
      notifyListeners();
      showToast(text: 'انتظر جارى انشاء الخبر', state: ToastStates.SUCCESS);
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://iffsma-2030.com/public/api/v1/create/sport_service'));
      request.fields.addAll({
        'title': title,
        'description': description,
        'video_link': link,
        'sport_service_category_id': categoryID,
        'tell_about_yourself': tellAboutYourSelf,
        'publisher_name': publisherName,
        'publisher_age': '0',
        'publisher_country': publisherCountry,
        'user_id': id.toString(),
      });
      for (var element in pickedImage) {
        request.files
            .add(await http.MultipartFile.fromPath('images[]', element.path));
      }
      if (pickedImagePublish != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'publisher_country_image', pickedImagePublish!.path));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final decodedData = json.decode(data);
      if (response.statusCode == 200) {
        showToast(
            text: 'انتظر قبول الخبر من المسئول', state: ToastStates.SUCCESS);
        isLoading = false;
        notifyListeners();
      } else {
        showToast(text: decodedData['message'], state: ToastStates.ERROR);
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> deleteNews(String category) async {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'http://iffsma-2030.com/public/api/v1/delete/sport_service?id=$category&user_id=$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    final decodedData = json.decode(data);
    if (response.statusCode == 200) {
      showToast(text: 'تم الحذف بنجاح', state: ToastStates.SUCCESS);
    } else {
      showToast(text: decodedData['message'], state: ToastStates.ERROR);
    }
  }

  Future<void> addComment(int serviceID, String comment) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    var userID = CacheHelper.getData(key: 'id') ?? '';
    var url = Uri.parse(
        'http://iffsma-2030.com/public/api/v1/sport_service/addComment');
    Map<String, dynamic> serviceModel = {
      'user_id': userID.toString(),
      'sport_service_id': serviceID.toString(),
      'comment': comment,
    };
    var body1 = jsonEncode(serviceModel);
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

  Future<void> getComments(int serviceID) async {
    comments = [];
    String token = CacheHelper.getData(key: 'token') ?? '';
    var url = Uri.parse(
        'http://iffsma-2030.com/public/api/v1/sport_service/getComments?sport_service_id=$serviceID');
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
        comments.add(SportServicesCommentsModel.fromJSON(element));
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }
}
