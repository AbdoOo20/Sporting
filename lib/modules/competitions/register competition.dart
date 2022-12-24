// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/models/user%20model.dart';
import 'package:news/modules/competitions/Competitions.dart';
import 'package:news/providers/competition%20provider.dart';
import 'package:news/providers/other%20provider.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';

class RegisterCompetition extends StatefulWidget {
  String competitionID;

  RegisterCompetition(this.competitionID, {Key? key}) : super(key: key);

  @override
  State<RegisterCompetition> createState() => _RegisterCompetitionState();
}

class _RegisterCompetitionState extends State<RegisterCompetition> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController videoLink = TextEditingController();
  late CompetitionProvider competitionProvider;
  late UserProvider userProvider;
  late OtherProvider otherProvider;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getUserData(currentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    competitionProvider = Provider.of(context);
    userProvider = Provider.of(context);
    otherProvider = Provider.of(context);
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const Competitions());
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: sizeFromWidth(context, 1),
          height: sizeFromHeight(context, 1, hasAppBar: true),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                textFormField(
                  controller: name,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'يجب إدخال اسم المتسابق';
                    }
                    return null;
                  },
                  hint: 'أدخل اسم المتسابق',
                ),
                textFormField(
                  controller: position,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'يجب إدخال مركز المتسابق';
                    }
                    return null;
                  },
                  hint: 'أدخل مركز المتسابق',
                ),
                textFormField(
                  controller: videoLink,
                  type: TextInputType.text,
                  validate: (value) {
                    return null;
                  },
                  hint: 'أدخل رابط فيديو',
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'اختر الفيديو',
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                          () {
                            competitionProvider.pickVideo();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'اختر صورة الدولة',
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                          () {
                            competitionProvider.selectCountryImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'اختر صورة النادى',
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                          () {
                            competitionProvider.selectClubImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sizeFromHeight(context, 10)),
                if (!competitionProvider.isLoading)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            'شارك بالمسابقة',
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () async {
                              if (formKey.currentState!.validate()) {
                                competitionProvider.shareInCompetition(
                                  widget.competitionID,
                                  name.text.trim(),
                                  position.text.trim(),
                                  userProvider.userModel as UserModel,
                                  videoLink.text.trim(),
                                );
                                var competition = await FirebaseFirestore
                                    .instance
                                    .collection('competition')
                                    .doc(widget.competitionID)
                                    .get();
                                otherProvider.sendNotification(
                                    'يوجد شخص جديد يريد المشاركة فى مسابقة ${competition['name']}');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (competitionProvider.isLoading)
                  Center(
                    child: circularProgressIndicator(lightGrey, primaryColor),
                  ),
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
          ),
        ),
      ),
    );
  }
}
