// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/profile/edit%20profile.dart';
import 'package:news/modules/profile/report.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class Profile extends StatefulWidget {
  String id;
  String page;

  Profile(this.id, this.page, {Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserProvider userProvider;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getUserData(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
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
                  image: AssetImage('assets/images/icon.jpeg'),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: widget.page == 'chat'
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  navigatePop(context);
                },
              )
            : IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  navigateAndFinish(context, const Home());
                },
              ),
      ),
      body: ConditionalBuilder(
        condition: userProvider.userModel != null,
        builder: (context) {
          return SizedBox(
            width: sizeFromWidth(context, 1),
            height: sizeFromHeight(context, 1, hasAppBar: true),
            child: Column(
              children: [
                SizedBox(height: sizeFromHeight(context, 90, hasAppBar: true)),
                Center(
                  child: Stack(
                    alignment: currentUser == widget.id ? Alignment.bottomLeft : Alignment.topLeft,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: sizeFromHeight(context, 15),
                        backgroundColor: white,
                        child: CircleAvatar(
                          radius: sizeFromHeight(context, 16),
                          backgroundColor: primaryColor,
                          backgroundImage: userProvider.userModel!.image != ''
                              ? NetworkImage(userProvider.userModel!.image)
                              : null,
                        ),
                      ),
                      if (widget.id == currentUser && widget.page != 'chat')
                        InkWell(
                          onTap: () {
                            userProvider.changeUserImage(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child:
                                Icon(Icons.camera_alt_outlined, color: black),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.id != currentUser)
                      InkWell(
                        onTap: (){
                          navigateTo(context, Report(widget.id));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                          child: textWidget(
                            'إبلاغ',
                            null,
                            TextAlign.center,
                            white,
                            sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryColor,
                      ),
                      child: textWidget(
                        userProvider.userModel!.userName,
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Container(
                        width: sizeFromWidth(context, 1),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(),
                        ),
                        child: Column(
                          children: [
                            if (widget.id == currentUser && widget.page != 'chat')
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        navigateAndFinish(
                                            context, EditProfile(widget.id));
                                      },
                                      child: textWidget(
                                        'تعديل',
                                        null,
                                        null,
                                        primaryColor,
                                        sizeFromWidth(context, 20),
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.info, color: white),
                                ],
                              ),
                            textWidget(
                              userProvider.userModel!.about,
                              null,
                              TextAlign.end,
                              white,
                              sizeFromWidth(context, 25),
                              FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              height: sizeFromHeight(context, 8.5),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      textWidget(
                                        'حساباتى',
                                        null,
                                        TextAlign.end,
                                        white,
                                        sizeFromWidth(context, 20),
                                        FontWeight.bold,
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(Icons.manage_accounts_sharp,
                                          color: white),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          dynamic link = Uri.parse(
                                              userProvider.userModel!.facebook);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    '${userProvider.userModel!.userName} Do not put facebook link or there are error in link',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.facebook,
                                            color: white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          dynamic link = Uri.parse(
                                              userProvider.userModel!.snapchat);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    '${userProvider.userModel!.userName} Do not put snapchat link or there are error in link',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.snapchat,
                                            color: white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          dynamic link = Uri.parse(
                                              userProvider.userModel!.tiktok);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    '${userProvider.userModel!.userName} Do not put tiktok link or there are error in link',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.tiktok,
                                            color: white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          dynamic link = Uri.parse(userProvider
                                              .userModel!.instagram);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    '${userProvider.userModel!.userName} Do not put instagram link or there are error in link',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.instagram,
                                            color: white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          dynamic link = Uri.parse(
                                              userProvider.userModel!.twitter);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    '${userProvider.userModel!.userName} Do not put twitter link or there are error in link',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.twitter,
                                            color: white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: sizeFromHeight(context, 8),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.location_on, color: white),
                                  textWidget(
                                    userProvider.userModel!.country,
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.email, color: white),
                                      Expanded(
                                        child: textWidget(
                                          currentUser == widget.id ? userProvider.userModel!.email : 'بيانات خاصة بصاحب الحساب',
                                          null,
                                          TextAlign.end,
                                          white,
                                          sizeFromWidth(context, 30),
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.call, color: white),
                                      Expanded(
                                        child: textWidget(
                                          currentUser == widget.id ? userProvider.userModel!.phone : 'بيانات خاصة بصاحب الحساب',
                                          null,
                                          TextAlign.end,
                                          white,
                                          sizeFromWidth(context, 30),
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: sizeFromHeight(context, 10),
                            width: sizeFromWidth(context, 5),
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                    userProvider.userModel!.kind == 'ذكر'
                                        ? Icons.male
                                        : Icons.female,
                                    color: white),
                                textWidget(
                                  userProvider.userModel!.kind,
                                  null,
                                  TextAlign.center,
                                  white,
                                  sizeFromWidth(context, 20),
                                  FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
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
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(lightGrey, primaryColor),
          );
        },
      ),
    );
  }
}
