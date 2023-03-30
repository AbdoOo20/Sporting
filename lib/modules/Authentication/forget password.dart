import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news/modules/Authentication/log%20in.dart';
import 'package:provider/provider.dart';

import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController name = TextEditingController();
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const LogIn());
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
                      'نسيت كلمة السر ؟',
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
                      'قم بتحديثها الان',
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
                    controller: name,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'يجب إدخال الإسم المسجل بحسابك';
                      }
                      return null;
                    },
                    hint: 'أدخل الاسم المسجل بحسابك',
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
                    hint: 'أدخل كلمة السر الجديدة',
                  ),
                  textFormField(
                    controller: newPassword,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'كلمة السر ضعيفة';
                      }
                      return null;
                    },
                    hint: 'تأكيد كلمة السر الجديدة',
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
                              'تحديث كلمة السر',
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                              () {
                                if (password.text != newPassword.text) {
                                  showToast(
                                      text: 'يجب التأكد من تطابق كلمة المرور',
                                      state: ToastStates.WARNING);
                                } else if (formKey.currentState!.validate()) {
                                  userProvider.checkExistAccount(
                                    email.text.trim(),
                                    password.text.trim(),
                                    newPassword.text.trim(),
                                    name.text.trim(),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
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
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
