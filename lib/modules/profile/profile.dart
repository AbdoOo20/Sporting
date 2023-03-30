// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/profile/report.dart';
import 'package:news/providers/chat%20provider.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/cash_helper.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

import '../../shared/const.dart';
import '../home/home.dart';
import 'edit profile.dart';

class Profile extends StatefulWidget {
  String token;
  String page;
  String chatID;
  bool isChatAdmin;
  bool isUserBlocked;

  Profile(
      this.token, this.page, this.isChatAdmin, this.isUserBlocked, this.chatID,
      {Key? key})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserProvider userProvider;
  late ChatProvider chatProvider;

  showAlertDialog(BuildContext context) {
    Widget cancelButton = textButton(
      context,
      'رجوع',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        navigatePop(context);
      },
    );
    Widget continueButton = textButton(
      context,
      'حذف',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        Provider.of<UserProvider>(context, listen: false)
            .deleteAccount(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        'هل أنت متأكد من حذف حسابك ؟',
        null,
        TextAlign.end,
        black,
        sizeFromWidth(context, 25),
        FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: continueButton),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: cancelButton),
            ],
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var token = CacheHelper.getData(key: 'token');
    var id = CacheHelper.getData(key: 'id');
    userProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
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
        actions: [
          if (token == widget.token && widget.page != 'chat')
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showAlertDialog(context);
              },
            ),
        ],
      ),
      body: ConditionalBuilder(
        condition: !userProvider.isLoading,
        builder: (context) {
          return SizedBox(
            width: sizeFromWidth(context, 1),
            height: sizeFromHeight(context, 1, hasAppBar: true),
            child: Column(
              children: [
                SizedBox(height: sizeFromHeight(context, 90, hasAppBar: true)),
                Center(
                  child: Stack(
                    alignment: token == widget.token
                        ? Alignment.bottomLeft
                        : Alignment.topLeft,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: sizeFromHeight(context, 15),
                        backgroundColor: white,
                        child: CircleAvatar(
                          radius: sizeFromHeight(context, 16),
                          backgroundColor: primaryColor,
                          backgroundImage: userModel.image != ''
                              ? NetworkImage(userModel.image)
                              : null,
                        ),
                      ),
                      if (token == widget.token && widget.page != 'chat')
                        InkWell(
                          onTap: () {
                            userProvider.changeUserImage(context, token);
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
                    if (token != widget.token && id.toString() != widget.token)
                      InkWell(
                        onTap: () {
                          navigateTo(context, Report(widget.token));
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
                        userModel.name,
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                    ),
                    if (token != widget.token &&
                        id.toString() != widget.token &&
                        widget.isChatAdmin)
                      InkWell(
                        onTap: () {
                          chatProvider.blockUser(widget.chatID, widget.token);
                          widget.isUserBlocked = !widget.isUserBlocked;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primaryColor,
                          ),
                          child: textWidget(
                            widget.isUserBlocked ? 'إلغاء الحظر' : 'حظر',
                            null,
                            TextAlign.center,
                            white,
                            sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
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
                            if (token == widget.token && widget.page != 'chat')
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
                                            context,
                                            EditProfile(
                                                token,
                                                widget.isChatAdmin,
                                                widget.isUserBlocked,
                                                widget.chatID));
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
                              userModel.bio,
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
                                          dynamic link =
                                              Uri.parse(userModel.facebook);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.facebook,
                                            color: white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          dynamic link =
                                              Uri.parse(userModel.snapchat);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.snapchat,
                                            color: white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          dynamic link =
                                              Uri.parse(userModel.tiktok);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.tiktok,
                                            color: white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          dynamic link =
                                              Uri.parse(userModel.instagram);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    'لم يتم وضع رابط أو يوجد خطأ بالرابط',
                                                state: ToastStates.ERROR);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.instagram,
                                            color: white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          dynamic link =
                                              Uri.parse(userModel.twitter);
                                          try {
                                            await launchUrl(link);
                                          } catch (e) {
                                            showToast(
                                                text:
                                                    'لم يتم وضع رابط أو يوجد خطأ بالرابط',
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
                                    userModel.country,
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
                                          token == widget.token
                                              ? userModel.email
                                              : 'بيانات خاصة بصاحب الحساب',
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
                                          token == widget.token
                                              ? userModel.phone
                                              : 'بيانات خاصة بصاحب الحساب',
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
                                    userModel.type == 'ذكر'
                                        ? Icons.male
                                        : Icons.female,
                                    color: white),
                                textWidget(
                                  userModel.type,
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
                bottomScaffoldWidget(context),
              ],
            ),
          );
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(lightGrey, primaryColor, context),
          );
        },
      ),
    );
  }
}
