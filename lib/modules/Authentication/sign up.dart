import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/Authentication/log%20in.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:news/shared/Components.dart';
import 'package:provider/provider.dart';

import '../../models/authenticate/register model.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
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
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
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
                  SizedBox(height: sizeFromHeight(context, 20)),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      'إنشاء حساب جديد',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: primaryColor),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      'قم بإنشاء حساب الان و تصفح التطبيق',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: darkGrey,
                            height: 0.2,
                          ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
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
                            RegisterModel userModel = RegisterModel(
                              userName: userName.text.trim(),
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                            userProvider.userRegister(context, userModel);
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
                      child: circularProgressIndicator(
                          lightGrey, primaryColor, context),
                    ),
                ],
              ),
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
