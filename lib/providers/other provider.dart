import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/models/other/setting%20model.dart';
import 'package:news/shared/Components.dart';
import 'package:http/http.dart' as http;
import 'package:news/shared/const.dart';

import '../models/other/banner model.dart';

class OtherProvider with ChangeNotifier {

  Future<void> getBanners() async {
    upBanners = [];
    downBanners = [];
    var url = Uri.parse('http://iffsma-2030.com/public/api/v1/banners');
    var response = await http.get(url, headers: {'Accept': 'application/json'});
    Map<String, dynamic> data = json.decode(response.body);
    var bannerList = data['data'];
    if (response.statusCode == 200) {
      bannerList.forEach((element) {
        if (element['type'] == 'down') {
          downBanners.add(BannerModel.fromJSON(element));
        } else if (element['type'] == 'up') {
          upBanners.add(BannerModel.fromJSON(element));
        }
      });
      notifyListeners();
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void getSettings() async {
    var url = Uri.parse('http://iffsma-2030.com/public/api/v1/setting');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> getData = json.decode(response.body);
    if (response.statusCode == 200) {
      settingModel = SettingModel.fromJSON(getData['data']);
      notifyListeners();
    } else {
      showToast(text: getData['message'], state: ToastStates.ERROR);
      notifyListeners();
    }
  }

  void addVisitor() async {
    var headers = {
      'Accept': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://iffsma-2030.com/public/api/v1/add/visitor'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {}
    else {}
  }

  Future<void> sendVideoComment(String title, String comment) async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();
    FirebaseFirestore.instance.collection('commentVideo').add({
      'title': title,
      'time': Timestamp.now().toString(),
      'comment': comment,
      'id': currentUser,
      'name': user['userName'],
      'image': user['image'],
      'dateTimePerDay': DateFormat.yMMMd().format(DateTime.now()),
      'dateTimePerHour': DateFormat.jm().format(DateTime.now()),
    });
    showToast(text: 'تم إرسال التعليق', state: ToastStates.SUCCESS);
  }

  void deleteComment(String id) {
    FirebaseFirestore.instance.collection('commentVideo').doc(id).delete();
  }

  void sendNotification(String text) {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('notifications').add({
      'sender': currentUser,
      'receiver': 'Admin',
      'time': Timestamp.now(),
      'text': text,
      'dateTimePerDay': DateFormat.yMMMd().format(DateTime.now()),
      'dateTimePerHour': DateFormat.jm().format(DateTime.now()),
    });
  }
}
