import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/Components.dart';

class StoreProvider with ChangeNotifier {
  bool isLoading = false;
  var picker = ImagePicker();
  List<File> pickedImage = [];
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

  Future<void> createChampionItem(String championName, String link) async {
    dynamic imageName = '';
    dynamic url = '';
    if (pickedImage.isEmpty) {
      showToast(text: 'يجب إختيار بعض الصور', state: ToastStates.ERROR);
    }
    if (pickedImage.isNotEmpty) {
      isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance.collection('store').add({
        'name': championName,
        'time': Timestamp.now(),
        'image': url,
        'imageName': '',
        'link': link,
        'storeId': '',
        'state': 'reject'
      }).then((value) async {
        FirebaseFirestore.instance.collection('store').doc(value.id).update({
          'storeId': value.id,
        });
        List<String> urlList = [];
        for (var image in pickedImage) {
          imageName = Uri.file(image.path).pathSegments.last;
          final ref = FirebaseStorage.instance
              .ref()
              .child('store image')
              .child(value.id)
              .child(imageName);
          await ref.putFile(image);
          url = await ref.getDownloadURL();
          urlList.add(url);
          if (pickedImage[0] == image) {
            FirebaseFirestore.instance
                .collection('store')
                .doc(value.id)
                .update({'image': url});
          }
          notifyListeners();
        }
      });

      pickedImage = [];
      isLoading = false;
      showToast(
          text: 'تم إنشاء الأيفونة بنجاح انتظر القبول من المشرف',
          state: ToastStates.SUCCESS);
      notifyListeners();
    }
  }

  void getImages(String storeID) {
    links = [];
    FirebaseStorage.instance
        .ref()
        .child('store image')
        .child(storeID)
        .list()
        .then((value) {
      for (var element in value.items) {
        element.getDownloadURL().then((value) {
          links.add(value);
          notifyListeners();
        });
        notifyListeners();
      }
      notifyListeners();
    });
  }
}
