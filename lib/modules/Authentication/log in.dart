
import 'package:flutter/material.dart';
import 'package:news/models/authenticate/login%20model.dart';
import 'package:news/modules/Authentication/forget%20password.dart';
import 'package:news/modules/Authentication/sign%20up.dart';
import 'package:provider/provider.dart';

import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
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
        title: appBarWidget(context),
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
                  SizedBox(height: sizeFromHeight(context, 20)),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      'مرحبا بعودتك',
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
                      'قم بالتسجيل الان و تصفح التطبيق',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: darkGrey,
                        height: 0.2,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  SizedBox(height: sizeFromHeight(context, 50)),
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
                  if (!userProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: textButton(
                              context,
                              'هل نسيت كلمة السر ؟',
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                                  () {
                                navigateAndFinish(context, const ForgetPassword());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (userProvider.isLoading)
                    Center(
                      child: circularProgressIndicator(lightGrey, primaryColor, context),
                    ),
                ],
              ),
            ),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
