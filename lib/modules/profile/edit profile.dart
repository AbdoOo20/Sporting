// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news/modules/profile/profile.dart';
import 'package:provider/provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class EditProfile extends StatefulWidget {
  String token;
  String chatID;
  bool isChatAdmin;
  bool isUserBlocked;

  EditProfile(this.token, this.isChatAdmin, this.isUserBlocked, this.chatID,{Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController kind = TextEditingController();
  final TextEditingController about = TextEditingController();
  final TextEditingController facebook = TextEditingController();
  final TextEditingController instagram = TextEditingController();
  final TextEditingController twitter = TextEditingController();
  final TextEditingController snapchat = TextEditingController();
  final TextEditingController tiktok = TextEditingController();
  late UserProvider userProvider;

  @override
  void initState() {
    userName.text = userModel.name;
    phone.text = userModel.phone;
    country.text = userModel.country;
    kind.text = userModel.type;
    about.text = userModel.bio;
    facebook.text = userModel.facebook;
    instagram.text = userModel.instagram;
    twitter.text = userModel.twitter;
    tiktok.text = userModel.tiktok;
    snapchat.text = userModel.snapchat;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'IFMIS',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: sizeFromWidth(context, 23),
                color: white,
              ),
            ),
            Container(
              height: sizeFromHeight(context, 15, hasAppBar: true),
              width: sizeFromWidth(context, 5),
              decoration: const BoxDecoration(
                color: Color(0xFFbdbdbd),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo 2.jpeg'),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            navigateAndFinish(context, Profile(widget.token, 'edit', widget.isChatAdmin, widget.isUserBlocked, widget.chatID));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: sizeFromHeight(context, 50)),
                  textFormField(
                      controller: userName,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'اسم المستخدم قصير';
                        }
                        return null;
                      },
                      hint: 'أدخل اسم المستخدم',
                  ),
                  textFormField(
                    controller: phone,
                    type: TextInputType.number,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'رقم الهاتف قصير';
                      }
                      return null;
                    },
                    hint: 'أدخل رقم الهاتف',
                  ),
                  textFormField(
                    controller: country,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'اسم الدولة قصير';
                      }
                      return null;
                    },
                    hint: 'أدخل الدولة بالمنطقة التابع لها',
                  ),
                  textFormField(
                    controller: kind,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value != 'ذكر' && value != 'أنثى') {
                        return 'يجب كتابة ذكر أو أنثى فى هذه الخانه';
                      }
                      return null;
                    },
                    hint: 'أدخل الجنس',
                  ),
                  textFormField(
                    controller: about,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: 'أدخل النبذة التعريفية الخاصة بك',
                  ),
                  textFormField(
                    controller: facebook,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: 'أدخل رابط الفيس بوك الخاص بك',
                  ),
                  textFormField(
                    controller: instagram,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: 'أدخل رابط الإنستجرام الخاص بك',
                  ),
                  textFormField(
                    controller: twitter,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: 'أدخل رابط التويتر الخاص بك',
                  ),
                  textFormField(
                    controller: snapchat,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: 'أدخل رابط الاسناب شات الخاص بك',
                  ),
                  textFormField(
                    controller: tiktok,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    hint: 'أدخل رابط التيك توك الخاص بك',
                  ),
                  if (!userProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: textButton(
                        context,
                        'تعديل بيانات حسابك',
                        primaryColor,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                        () {
                          if (formKey.currentState!.validate()) {
                            userProvider.updateUserData(
                              context,
                              widget.token,
                              userName.text.trim(),
                              phone.text.trim(),
                              kind.text.trim(),
                              country.text.trim(),
                              about.text.trim(),
                              facebook.text.trim(),
                              instagram.text.trim(),
                              twitter.text.trim(),
                              snapchat.text.trim(),
                              tiktok.text.trim(),
                            );
                          }
                        },
                      ),
                    ),
                  if (userProvider.isLoading)
                    Center(
                      child: circularProgressIndicator(lightGrey, primaryColor, context),
                    ),
                ],
              ),
            ),
          ),
          Container(
                  color: primaryColor,
                  height: sizeFromHeight(context, 10),
                  width: sizeFromWidth(context, 1),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: CarouselSlider(
                      items: downBanners.map((e) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(e.image),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 250,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        viewportFraction: 1,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
