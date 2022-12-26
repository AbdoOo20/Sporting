import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/models/authenticate/login%20model.dart';
import 'package:news/modules/Authentication/sign%20up.dart';
import 'package:provider/provider.dart';

import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../home/home.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
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
                  image: AssetImage('assets/images/logo 2.jpeg'),
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
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: sizeFromHeight(context, 5)),
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
                  if (!userProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: textButton(
                              context,
                              'تسجيل الدخول',
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                              () {
                                if (formKey.currentState!.validate()) {
                                  LoginModel loginModel = LoginModel(
                                    email: email.text.trim(),
                                    password: password.text.trim(),
                                  );
                                  userProvider.userLogin(context, loginModel, 'login');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!userProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: textButton(
                              context,
                              'إنشاء حساب',
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                              () {
                                navigateAndFinish(context, const SignUP());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (userProvider.isLoading)
                    Center(
                      child: circularProgressIndicator(lightGrey, primaryColor),
                    ),
                ],
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
      ),
    );
  }
}
