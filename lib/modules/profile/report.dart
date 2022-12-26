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
              padding: EdgeInsets.all(sizeFromWidth(context, 20)),
              margin: const EdgeInsets.all(5),
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
              circularProgressIndicator(lightGrey, primaryColor),
            const Spacer(),
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
