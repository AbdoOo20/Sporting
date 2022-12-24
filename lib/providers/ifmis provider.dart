import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../shared/Components.dart';

class IFMISProvider with ChangeNotifier {
  bool isLoading = false;
  var picker = ImagePicker();
  List<File> pickedImage = [];
  File? pickedVideo;
  List links = [];

  void pickImage() async {
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      pickedImage.add(File(pickedImageFile.path));
      notifyListeners();
    }
    if (pickedImage.isNotEmpty) {
      showToast(
          text: 'تم إختيار الصورة بنجاح و يمكنك اختيار العديد من الصور',
          state: ToastStates.SUCCESS);
    }
  }

  void pickVideo() async {
    try {
      var pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 120),
      );
      if (pickedFile != null) {
        pickedVideo = File(pickedFile.path);
        VideoPlayerController videoPlayerController =
            VideoPlayerController.file(File(pickedFile.path));
        await videoPlayerController.initialize();
        if (videoPlayerController.value.duration.inSeconds > 120) {
          pickedFile = null;
          pickedVideo = null;
          notifyListeners();
          showToast(
              text: 'لا يتم اختيار فيديو يتخطى الدقيقتين',
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

  void createVisit(String title, String content) async{
    dynamic imageName = '';
    dynamic url = '';
    if (pickedImage.isEmpty) {
      showToast(text: 'يجب إختيار بعض الصور', state: ToastStates.ERROR);
    }
    if (pickedVideo == null) {
      showToast(text: 'يجب إختيار فيديو لا يتخطى الدقيقتين', state: ToastStates.ERROR);
    }
    if (pickedImage.isNotEmpty && pickedVideo != null) {
      showToast(
          text: 'انتظر حتى يتم تخزين البيانات',
          state: ToastStates.WARNING);
      isLoading = true;
      notifyListeners();
      String videoText = Uri.file(pickedVideo!.path).pathSegments.last;
      var refVideo = FirebaseStorage.instance
          .ref()
          .child('ifmis video')
          .child(videoText);
      await refVideo.putFile(pickedVideo!);
      final video = await refVideo.getDownloadURL();
      await FirebaseFirestore.instance.collection('ifmis').add({
        'title': title,
        'content': content,
        'time': Timestamp.now(),
        'image': url,
        'imageName': '',
        'video': video,
        'videoName': videoText,
        'id': '',
      }).then((value) async {
        FirebaseFirestore.instance.collection('ifmis').doc(value.id).update({
          'id': value.id,
        });
        List<String> urlList = [];
        for (var image in pickedImage) {
          imageName = Uri.file(image.path).pathSegments.last;
          final ref = FirebaseStorage.instance
              .ref()
              .child('ifmis image')
              .child(value.id)
              .child(imageName);
          await ref.putFile(image);
          url = await ref.getDownloadURL();
          urlList.add(url);
          if (pickedImage[0] == image) {
            FirebaseFirestore.instance
                .collection('ifmis')
                .doc(value.id)
                .update({'image': url});
          }
          notifyListeners();
        }
      });
      pickedImage = [];
      pickedVideo = null;
      isLoading = false;
      showToast(
          text: 'تم إنشاء الزيارة بنجاح',
          state: ToastStates.SUCCESS);
      notifyListeners();
    }
  }

  void getImages(String storeID) {
    links = [];
    FirebaseStorage.instance
        .ref()
        .child('ifmis image')
        .child(storeID)
        .list()
        .then((value) {
      for (var element in value.items) {
        element.getDownloadURL().then((value) {
          links.add(value);
          notifyListeners();
        });
      }
    });
  }
}
