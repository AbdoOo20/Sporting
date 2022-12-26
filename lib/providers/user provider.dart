// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/models/authenticate/login%20model.dart';
import 'package:news/models/authenticate/user%20model.dart';
import 'package:news/modules/home/home.dart';
import 'package:news/network/cash_helper.dart';

import '../models/authenticate/register model.dart';
import '../shared/Components.dart';
import '../shared/const.dart';

class UserProvider with ChangeNotifier {
  bool isLoading = false;
  late UserCredential userCredential;
  final auth = FirebaseAuth.instance;
  File? reportImage;
  File? pickedImage;
  final picker = ImagePicker();
  int numberOfUsers = 0;
  int numberOfNotifications = 0;

  void userRegister(BuildContext context, RegisterModel registerModel) async {
    isLoading = true;
    notifyListeners();
    String body = json.encode(registerModel.toMap());
    var url = Uri.parse('http://iffsma-2030.com/public/api/v1/user/register');
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 201) {
      showToast(text: data['message'], state: ToastStates.SUCCESS);
      userModel = UserModel.fromJSON(data["data"]);
      CacheHelper.saveData(key: 'token', value: data['token']);
      CacheHelper.saveData(key: 'email', value: userModel.email);
      CacheHelper.saveData(key: 'password', value: registerModel.password);
      CacheHelper.saveData(key: 'id', value: userModel.id);
      CacheHelper.saveData(key: 'phone', value: userModel.phone);
      CacheHelper.saveData(key: 'name', value: userModel.name);
      CacheHelper.saveData(key: 'type', value: userModel.type);
      CacheHelper.saveData(key: 'country', value: userModel.country);
      CacheHelper.saveData(key: 'bio', value: '');
      CacheHelper.saveData(key: 'image', value: '');
      CacheHelper.saveData(key: 'facebook', value: '');
      CacheHelper.saveData(key: 'instagram', value: '');
      CacheHelper.saveData(key: 'twitter', value: '');
      CacheHelper.saveData(key: 'snapchat', value: '');
      CacheHelper.saveData(key: 'tiktok', value: '');
      showToast(text: 'تم التسجيل بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
      navigateAndFinish(context, const Home());
    } else if (response.statusCode == 422) {
      showToast(text: data['message'], state: ToastStates.ERROR);
      isLoading = false;
      notifyListeners();
    }
  }

  int numberOfRefusedEmail = 0;
  int numberOfExistEmailOrPhone = 0;

  void moveDataFromFirebaseToAPI() async {
    isLoading = true;
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        RegisterModel userModel = RegisterModel(
          userName: element['userName'],
          email: element['email'],
          password: element['password'],
          phone: element['phone'],
          country: element['country'],
          type: element['kind'],
        );
        String body = json.encode(userModel.toMap());
        var url =
            Uri.parse('http://iffsma-2030.com/public/api/v1/user/register');
        var response = await http.post(
          url,
          body: body,
          headers: {
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        );
        Map<String, dynamic> data = json.decode(response.body);
        if (response.statusCode == 201) {
          numberOfRefusedEmail++;
          log('Email Accepted: $numberOfRefusedEmail');
          log('Success at index: ${element.id}');
        } else {}
      }
    });
    isLoading = false;
    notifyListeners();
  }

  void userLogin(
      BuildContext context, LoginModel loginModel, String pageName) async {
    isLoading = true;
    notifyListeners();
    String body = json.encode(loginModel.toMap());
    var url = Uri.parse('http://iffsma-2030.com/public/api/v1/user/login');
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      userModel = UserModel.fromJSON(data["data"]);
      CacheHelper.saveData(key: 'token', value: data['token']);
      CacheHelper.saveData(key: 'email', value: userModel.email);
      CacheHelper.saveData(key: 'password', value: loginModel.password);
      CacheHelper.saveData(key: 'id', value: userModel.id);
      CacheHelper.saveData(key: 'phone', value: userModel.phone);
      CacheHelper.saveData(key: 'name', value: userModel.name);
      CacheHelper.saveData(key: 'type', value: userModel.type);
      CacheHelper.saveData(key: 'country', value: userModel.country);
      CacheHelper.saveData(key: 'bio', value: userModel.bio);
      CacheHelper.saveData(key: 'image', value: userModel.image);
      CacheHelper.saveData(key: 'facebook', value: userModel.facebook);
      CacheHelper.saveData(key: 'instagram', value: userModel.instagram);
      CacheHelper.saveData(key: 'twitter', value: userModel.twitter);
      CacheHelper.saveData(key: 'snapchat', value: userModel.snapchat);
      CacheHelper.saveData(key: 'tiktok', value: userModel.tiktok);
      if (pageName == 'login') {
        showToast(text: data['message'], state: ToastStates.SUCCESS);
      }
      isLoading = false;
      notifyListeners();
      navigateAndFinish(context, const Home());
    } else if (response.statusCode == 200 && data['status'] == false) {
      if (pageName == 'login') {
        showToast(text: data['message'], state: ToastStates.ERROR);
      }
      isLoading = false;
      notifyListeners();
    }
  }

  void userLogout(BuildContext context) async {
    var url = Uri.parse('http://iffsma-2030.com/public/api/v1/user/logout');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${CacheHelper.getData(key: 'token')}',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      showToast(text: data['message'], state: ToastStates.SUCCESS);
      CacheHelper.saveData(key: 'token', value: '');
      CacheHelper.saveData(key: 'email', value: '');
      CacheHelper.saveData(key: 'id', value: '');
      CacheHelper.saveData(key: 'phone', value: '');
      CacheHelper.saveData(key: 'name', value: '');
      CacheHelper.saveData(key: 'type', value: '');
      CacheHelper.saveData(key: 'country', value: '');
      CacheHelper.saveData(key: 'bio', value: '');
      CacheHelper.saveData(key: 'image', value: '');
      CacheHelper.saveData(key: 'facebook', value: '');
      CacheHelper.saveData(key: 'instagram', value: '');
      CacheHelper.saveData(key: 'twitter', value: '');
      CacheHelper.saveData(key: 'snapchat', value: '');
      CacheHelper.saveData(key: 'tiktok', value: '');
      navigateAndFinish(context, const Home());
    } else {
      showToast(text: data['message'], state: ToastStates.ERROR);
    }
  }

  void getDataUser(BuildContext context, String token) async {
    isLoading = true;
    userModel = UserModel(
      id: CacheHelper.getData(key: 'id'),
      name: CacheHelper.getData(key: 'name'),
      email: CacheHelper.getData(key: 'email'),
      phone: CacheHelper.getData(key: 'phone'),
      type: CacheHelper.getData(key: 'type'),
      bio: CacheHelper.getData(key: 'bio'),
      image: '',
      facebook: CacheHelper.getData(key: 'facebook'),
      instagram: CacheHelper.getData(key: 'instagram'),
      twitter: CacheHelper.getData(key: 'twitter'),
      snapchat: CacheHelper.getData(key: 'snapchat'),
      tiktok: CacheHelper.getData(key: 'tiktok'),
      country: CacheHelper.getData(key: 'country'),
    );
    String body = json.encode(userModel.toMap());
    var url =
        Uri.parse('http://iffsma-2030.com/public/api/v1/user/edit/profile');
    var response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      userModel = UserModel.fromJSON(data["data"]);
      userModel.image = CacheHelper.getData(key: 'image');
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDataOtherUser(BuildContext context, String id) async {
    String token = CacheHelper.getData(key: 'token');
    var url =
        Uri.parse('http://iffsma-2030.com/public/api/v1/user/profile?id=$id');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      userModel = UserModel.fromJSON(data["data"]);
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void changeUserImage(BuildContext context, String token) async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    pickedImage = File(pickedImageFile!.path);
    showToast(text: 'انتظر جارى تغيير الصورة', state: ToastStates.WARNING);
    isLoading = true;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('http://iffsma-2030.com/public/api/v1/user/edit/profile'));
    request.fields.addAll({
      'id': CacheHelper.getData(key: 'id').toString(),
      'name': CacheHelper.getData(key: 'name'),
      'email': CacheHelper.getData(key: 'email'),
      'phone': CacheHelper.getData(key: 'phone'),
      'type': CacheHelper.getData(key: 'type'),
      'bio': '',
      'facebook': '',
      'instagram': '',
      'twitter': '',
      'snapchat': '',
      'tiktok': '',
      'country': CacheHelper.getData(key: 'country'),
    });
    request.files
        .add(await http.MultipartFile.fromPath('image', pickedImageFile.path));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      LoginModel loginModel = LoginModel(
        email: CacheHelper.getData(key: 'email'),
        password: CacheHelper.getData(key: 'password'),
      );
      userLogin(context, loginModel, '');
      showToast(text: 'تم تغيير الصورة بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateUserData(
    BuildContext context,
    String token,
    String name,
    String phone,
    String type,
    String country,
    String bio,
    String facebook,
    String instagram,
    String twitter,
    String snapchat,
    String tiktok,
  ) async {
    isLoading = true;
    notifyListeners();
    userModel = UserModel(
      id: CacheHelper.getData(key: 'id'),
      name: name,
      email: CacheHelper.getData(key: 'email'),
      phone: phone,
      type: type,
      bio: bio,
      image: '',
      facebook: facebook,
      instagram: instagram,
      twitter: twitter,
      snapchat: snapchat,
      tiktok: tiktok,
      country: country,
    );
    String body = json.encode(userModel.toMap());
    var url =
        Uri.parse('http://iffsma-2030.com/public/api/v1/user/edit/profile');
    var response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      userModel = UserModel.fromJSON(data["data"]);
      userModel.image = CacheHelper.getData(key: 'image');
      CacheHelper.saveData(key: 'phone', value: phone);
      CacheHelper.saveData(key: 'name', value: name);
      CacheHelper.saveData(key: 'type', value: type);
      CacheHelper.saveData(key: 'country', value: country);
      CacheHelper.saveData(key: 'bio', value: bio);
      CacheHelper.saveData(key: 'facebook', value: facebook);
      CacheHelper.saveData(key: 'instagram', value: instagram);
      CacheHelper.saveData(key: 'twitter', value: twitter);
      CacheHelper.saveData(key: 'snapchat', value: snapchat);
      CacheHelper.saveData(key: 'tiktok', value: tiktok);
      showToast(text: 'تم تحديث البيانات بنجاح', state: ToastStates.SUCCESS);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectReportImage() async {
    var pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    reportImage = File(pickedImageFile!.path);
  }

  Future<void> sendReport(String userReported, String reason) async {
    String token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    isLoading = true;
    notifyListeners();
    var request = http.MultipartRequest('POST',
        Uri.parse('http://iffsma-2030.com/public/api/v1/send/communication'));
    request.fields.addAll({
      'user_id': id.toString(),
      'reported_id': userReported,
      'message': reason,
    });
    if (reportImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('proof_image', reportImage!.path));
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      showToast(
          text: 'تم إرسال البلاغ للمسئول بنجاح', state: ToastStates.SUCCESS);
    } else {
      showToast(text: 'يوجد خطأ', state: ToastStates.ERROR);
    }
    isLoading = false;
    notifyListeners();
  }

  void getNumberOfNotifications() {
    numberOfNotifications = 0;
    var id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('notifications').get().then((value) {
      for (var element in value.docs) {
        if (element['receiver'] == id) {
          numberOfNotifications++;
        }
        notifyListeners();
      }
    });
  }
}
