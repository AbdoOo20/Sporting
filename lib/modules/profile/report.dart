// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class Report extends StatefulWidget {
  String id;

  Report(this.id, {Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController reason = TextEditingController();
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
      ),
      body: SizedBox(
        width: sizeFromWidth(context, 1),
        height: sizeFromHeight(context, 1, hasAppBar: true),
        child: Column(
          children: [
            textFormField(
              controller: reason,
              type: TextInputType.text,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'يجب كتابة سبب البلاغ';
                }
                return null;
              },
              hint: 'أكتب سبب البلاغ',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: textButton(
                      context,
                      'إرفاق صورة مع البلاغ',
                      primaryColor,
                      white,
                      sizeFromWidth(context, 20),
                      FontWeight.bold,
                      () async {
                        userProvider.selectReportImage();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sizeFromHeight(context, 50)),
            if (!userProvider.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: textButton(
                        context,
                        'أرسل البلاغ',
                        primaryColor,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                        () async {
                          if (reason.text.isEmpty) {
                            showToast(
                                text: 'اكتب سبب البلاغ',
                                state: ToastStates.ERROR);
                          } else {
                            userProvider
                                .sendReport(widget.id, reason.text.trim())
                                .then((value) {
                              reason.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (userProvider.isLoading)
              circularProgressIndicator(lightGrey, primaryColor, context),
            const Spacer(),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
