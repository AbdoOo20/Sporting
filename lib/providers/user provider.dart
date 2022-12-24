// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:news/models/user%20model.dart';
import 'package:news/modules/home/home.dart';
import 'package:news/modules/profile/profile.dart';
import 'package:news/network/cash_helper.dart';

import '../shared/Components.dart';

class UserProvider with ChangeNotifier {
  bool isLoading = false;
  late UserCredential userCredential;
  final auth = FirebaseAuth.instance;
  UserModel? userModel;
  File? pickedImage;
  final picker = ImagePicker();
  int numberOfUsers = 0;
  int numberOfNotifications = 0;

  void createUser(BuildContext context, UserModel userModel) async {
    try {
      isLoading = true;
      notifyListeners();
      userCredential = await auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({
          'id': userCredential.user!.uid,
        });
      });
      CacheHelper.saveData(key: 'email', value: userModel.email);
      showToast(text: 'Sign Up Done Successfully', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
      navigateAndFinish(context, const Home());
    } on FirebaseAuthException catch (e) {
      dynamic message = 'error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      showToast(text: message, state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void login(BuildContext context, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      CacheHelper.saveData(key: 'email', value: email);
      showToast(text: 'LogIn Done Successfully', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
      navigateAndFinish(context, const Home());
    } on FirebaseAuthException catch (e) {
      String message = 'error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      showToast(text: message, state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void getUserData(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data() as Map<String, dynamic>);
      notifyListeners();
    });
    notifyListeners();
  }

  void changeUserImage(BuildContext context) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    pickedImage = File(pickedImageFile!.path);
    notifyListeners();
    showToast(text: 'انتظر جارى تغيير الصورة', state: ToastStates.WARNING);
    var ref = FirebaseStorage.instance
        .ref()
        .child('user image')
        .child(currentUser!.uid);
    await ref.putFile(pickedImage!);
    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({
      'image': url,
    });
    showToast(
        text: 'تم تحديث الصورة الشخصية بنجاح', state: ToastStates.SUCCESS);
    navigateAndFinish(context, Profile(currentUser.uid, 'profile'));
  }

  void editUserData(UserModel userModel) {
    var currentUser = FirebaseAuth.instance.currentUser;
    isLoading = true;
    notifyListeners();
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update(userModel.toMap())
        .then((value) {
      isLoading = false;
      showToast(text: 'تم تحديث بياناتك بنجاح', state: ToastStates.SUCCESS);
      getUserData(userModel.id);
    });
  }

  Future<void> sendReport(String toId, String reason) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    isLoading = true;
    notifyListeners();
    var from = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    var to =
        await FirebaseFirestore.instance.collection('users').doc(toId).get();
    FirebaseFirestore.instance.collection('reports').add({
      'from': currentUser.uid,
      'fromImage': from['image'],
      'fromName': from['userName'],
      'to': toId,
      'toImage': to['image'],
      'toName': to['userName'],
      'reason': reason,
      'dateTimePerDay': DateFormat.yMMMd().format(DateTime.now()),
      'dateTimePerHour': DateFormat.jm().format(DateTime.now()),
      'createdAt': Timestamp.now().toString(),
    });
    showToast(text: 'تم إرسال البلاغ بنجاح', state: ToastStates.SUCCESS);
    isLoading = false;
    notifyListeners();
  }

  void getNumberOfUsers() {
    FirebaseFirestore.instance.collection('ips').get().then((value) {
      numberOfUsers = value.docs.length;
      notifyListeners();
    });
  }

  void setIpAddress(String ip) {
    FirebaseFirestore.instance.collection('ips').doc(ip).set({});
  }

  void getNumberOfNotifications() {
    numberOfNotifications = 0;
    var id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('notifications').get().then((value) {
      for (var element in value.docs) {
        if(element['receiver'] == id){
          numberOfNotifications++;
        }
        notifyListeners();
      }
    });
  }
}
