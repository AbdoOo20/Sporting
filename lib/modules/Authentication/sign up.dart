import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/models/user%20model.dart';
import 'package:news/modules/Authentication/log%20in.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:news/shared/Components.dart';
import 'package:provider/provider.dart';

import '../../shared/Style.dart';
import '../home/home.dart';

class SignUP extends StatefulWidget {
  const SignUP({Key? key}) : super(key: key);

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController kind = TextEditingController();
  late UserProvider userProvider;

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
                  image: AssetImage('assets/images/icon.jpeg'),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            navigateAndFinish(context, const Home());
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
                    controller: email,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'يجب أن يحتوى الايميل على @';
                      }
                      return null;
                    },
                    hint: 'أدخل البريد الإلكترونى',
                  ),
                  textFormField(
                    controller: password,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'كلمة السر ضعيفة';
                      }
                      return null;
                    },
                    hint: 'أدخل كلمة السر',
                  ),
                  textFormField(
                    controller: phone,
                    type: TextInputType.text,
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
                    hint: 'أدخل الدولة',
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
                  if (!userProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: textButton(
                        context,
                        'إنشاء حساب',
                        primaryColor,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                        () {
                          if (formKey.currentState!.validate()) {
                            UserModel userModel = UserModel(
                              userName: userName.text.trim(),
                              email: email.text.trim(),
                              password: password.text.trim(),
                              phone: phone.text.trim(),
                              country: country.text.trim(),
                              kind: kind.text.trim(),
                              image: '',
                              about: '',
                              id: '',
                              facebook: '',
                              instagram: '',
                              tiktok: '',
                              twitter: '',
                              snapchat: '',
                            );
                            userProvider.createUser(context, userModel);
                          }
                        },
                      ),
                    ),
                  if (!userProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: textButton(
                        context,
                        'تسجيل الدخول',
                        primaryColor,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                        () {
                          navigateAndFinish(context, const LogIn());
                        },
                      ),
                    ),
                  if (userProvider.isLoading)
                    Center(
                      child: circularProgressIndicator(lightGrey, primaryColor),
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
                items: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage('assets/images/banner2.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
