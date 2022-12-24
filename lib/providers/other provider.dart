import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/shared/Components.dart';

class OtherProvider with ChangeNotifier {
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
