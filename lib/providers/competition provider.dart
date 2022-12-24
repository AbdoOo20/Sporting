import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:news/models/user%20model.dart';
import 'package:news/shared/Components.dart';
import 'package:video_player/video_player.dart';

class CompetitionProvider with ChangeNotifier {
  bool isLoading = false;
  File? pickedImageCountry;
  File? pickedImageClub;
  File? pickedVideo;
  final picker = ImagePicker();
  String dateAfterEdit = '';
  int number = 0;
  double greatScore = 0;
  double score = 0;

  void selectCountryImage() async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    pickedImageCountry = File(pickedImageFile!.path);
    notifyListeners();
    if (pickedImageCountry != null) {
      showToast(
          text: 'تم اختيار صورة الدولة بنجاح', state: ToastStates.SUCCESS);
    }
  }

  void selectClubImage() async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    pickedImageClub = File(pickedImageFile!.path);
    notifyListeners();
    if (pickedImageCountry != null) {
      showToast(
          text: 'تم اختيار صورة النادى بنجاح', state: ToastStates.SUCCESS);
    }
  }

  void pickVideo() async {
    try {
      var pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60),
      );
      if (pickedFile != null) {
        pickedVideo = File(pickedFile.path);
        VideoPlayerController videoPlayerController =
            VideoPlayerController.file(File(pickedFile.path));
        await videoPlayerController.initialize();
        if (videoPlayerController.value.duration.inSeconds > 30) {
          pickedFile = null;
          pickedVideo = null;
          notifyListeners();
          showToast(
              text: 'لا يتم اختيار فيديو يتخطى ال 30 ثانيه',
              state: ToastStates.WARNING);
          notifyListeners();
        } else {
          showToast(
              text: 'تم اختيار الفيديو بنجاح', state: ToastStates.SUCCESS);
        }
      }
    } catch (e) {
      showToast(text: e.toString(), state: ToastStates.ERROR);
    }
  }

  void shareInCompetition(
    String competitionID,
    String nameCompetitor,
    String position,
    UserModel userModel,
    String videoLink,
  ) async {
    if (pickedImageCountry == null) {
      showToast(text: 'يجب اختيار صورة الدولة', state: ToastStates.ERROR);
    } else if (pickedImageClub == null) {
      showToast(text: 'يجب اختيار صورة النادى', state: ToastStates.ERROR);
    } else if (pickedVideo == null && videoLink == '') {
      showToast(
          text: 'يجب اختيار فيديو لا يزيد عن 30 ثانيه أو ضع رابط فيديو',
          state: ToastStates.ERROR);
    } else {
      isLoading = true;
      notifyListeners();
      showToast(text: 'جارى رفع الصور و الفيديو', state: ToastStates.ERROR);
      String countryText = Uri.file(pickedImageCountry!.path).pathSegments.last;
      var refCountry = FirebaseStorage.instance
          .ref()
          .child('country image')
          .child(countryText);
      await refCountry.putFile(pickedImageCountry!);
      final country = await refCountry.getDownloadURL();

      String clubText = Uri.file(pickedImageClub!.path).pathSegments.last;
      var refClub =
          FirebaseStorage.instance.ref().child('club image').child(clubText);
      await refClub.putFile(pickedImageClub!);
      final club = await refClub.getDownloadURL();

      String videoText = '';
      String video = '';
      if (pickedVideo != null) {
        videoText = Uri.file(pickedVideo!.path).pathSegments.last;
        var refVideo = FirebaseStorage.instance
            .ref()
            .child('competition videos')
            .child(videoText);
        await refVideo.putFile(pickedVideo!);
        video = await refVideo.getDownloadURL();
      }

      var currentUser = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('competition')
          .doc(competitionID)
          .collection('users')
          .doc(currentUser)
          .set({
        'video': videoLink == '' ? video : videoLink,
        'videoName': videoText,
        'club': club,
        'clubName': clubText,
        'country': country,
        'countryName': countryText,
        'nameCompetitor': nameCompetitor,
        'position': position,
        'image': userModel.image,
        'name': userModel.userName,
        'state': 'waiting',
        'time': Timestamp.now(),
        'score': 0.0,
        'users': [],
      });
      var usersWaiting = await FirebaseFirestore.instance
          .collection('competition')
          .doc(competitionID)
          .get();
      List users = usersWaiting['waiting'];
      users.add(currentUser);
      notifyListeners();
      FirebaseFirestore.instance
          .collection('competition')
          .doc(competitionID)
          .update({
        'waiting': users,
      });
      isLoading = false;
      pickedImageCountry = null;
      pickedImageClub = null;
      pickedVideo = null;
      notifyListeners();
      showToast(
          text: 'انتظر حتى يتم قبولك بالمسابقة', state: ToastStates.WARNING);
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

  Future<void> sendComment(
      String competitionID, String userID, String comment) async {
    log(competitionID);
    log(userID);
    var id = FirebaseAuth.instance.currentUser!.uid;
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    FirebaseFirestore.instance
        .collection('competition')
        .doc(competitionID)
        .collection('users')
        .doc(userID)
        .collection('comments')
        .add({
      'text': comment,
      'time': Timestamp.now(),
      'id': id,
      'name': userData['userName'],
      'image': userData['image'],
      'dateTimePerDay': DateFormat.yMMMd().format(DateTime.now()),
      'dateTimePerHour': DateFormat.jm().format(DateTime.now()),
    });
    notifyListeners();
  }

  void getCompetitionNumber(String competitionID) {
    score = 0;
    number = 0;
    FirebaseFirestore.instance
        .collection('competition')
        .doc(competitionID)
        .collection('users')
        .get()
        .then((value) {
      for (var element in value.docs) {
        score += element['score'];
      }
      var result = score / 0.01;
      number = result.round().toInt();
      notifyListeners();
    });
  }

  void getGoldenMedal(String competitionID) {
    greatScore = 0;
    FirebaseFirestore.instance
        .collection('competition')
        .doc(competitionID)
        .collection('users')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (greatScore < element['score']) {
          greatScore = element['score'];
        }
      }
      notifyListeners();
    });
  }
}
