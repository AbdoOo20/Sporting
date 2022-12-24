// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/other%20provider.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';

class Report extends StatefulWidget {
  String id;

  Report(this.id, {Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController reason = TextEditingController();
  late UserProvider userProvider;
  late OtherProvider otherProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    otherProvider = Provider.of(context);
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
                  image: AssetImage('assets/images/icon.jpeg'),
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
                          userProvider
                              .sendReport(widget.id, reason.text.trim())
                              .then((value) {
                            reason.clear();
                          });
                          var currentUser = FirebaseAuth.instance.currentUser;
                          var from = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser!.uid)
                              .get();
                          otherProvider.sendNotification(
                              'يوجد بلاغ جديد من ${from['userName']}');
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
                  items: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/banner2.png'),
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
      ),
    );
  }
}
