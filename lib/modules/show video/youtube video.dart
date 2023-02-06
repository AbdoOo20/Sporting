// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/show%20video/comment%20video.dart';
import 'package:news/providers/chat%20provider.dart';
import 'package:news/providers/competition%20provider.dart';
import 'package:news/providers/other%20provider.dart';
import 'package:news/shared/Components.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../network/cash_helper.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../Authentication/log in.dart';
import '../Authentication/sign up.dart';

class YoutubeVideo extends StatefulWidget {
  String videoLink;
  String pageName;
  int competitorId;

  YoutubeVideo(this.videoLink, this.pageName, this.competitorId, {Key? key})
      : super(key: key);

  @override
  State<YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  late ChatProvider chatProvider;
  late CompetitionProvider competitionProvider;

  showAlertDialog(BuildContext context) {
    Widget cancelButton = textButton(
      context,
      'تسجيل الدخول',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        navigateAndFinish(context, const LogIn());
      },
    );
    Widget continueButton = textButton(
      context,
      'إنشاء حساب',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        navigateAndFinish(context, const SignUP());
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        'يجب إنشاء حساب أو تسجيل الدخول',
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
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .initializeYoutubePlayer(widget.videoLink);
    if (widget.pageName == 'competition') {
      Provider.of<CompetitionProvider>(context, listen: false)
          .getComments(widget.competitorId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    competitionProvider = Provider.of(context);
    return Scaffold(
      appBar: chatProvider.youtubePlayerController.value.isFullScreen
          ? null
          : AppBar(
              iconTheme: IconThemeData(color: white),
              backgroundColor: primaryColor,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Text(
                    'IFMIS',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: sizeFromWidth(context, 23),
                      color: white,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
      body: ConditionalBuilder(
        condition: !chatProvider.youtubePlayerController.value.hasError,
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: YoutubePlayer(
                              controller: chatProvider.youtubePlayerController,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: primaryColor,
                              progressColors: ProgressBarColors(
                                playedColor: primaryColor,
                                handleColor: lightGrey,
                              ),
                            ),
                          ),
                          if (!chatProvider.youtubePlayerController.value.isFullScreen)
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      var url = Uri.parse(widget.videoLink);
                                      await launchUrl(url,
                                          mode: LaunchMode.inAppWebView);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      padding: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: textWidget(
                                        'الفيديو باليوتيوب',
                                        null,
                                        null,
                                        white,
                                        sizeFromWidth(context, 20),
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (!chatProvider.youtubePlayerController.value.isFullScreen)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: textWidget(
                                      'التعليقات',
                                      null,
                                      null,
                                      white,
                                      sizeFromWidth(context, 20),
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    for (int i = 0; i < competitionProvider.comments.length; i++)
                      if (widget.pageName == 'competition' && !chatProvider.youtubePlayerController.value.isFullScreen)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: materialWidget(
                                    context,
                                    null,
                                    sizeFromWidth(context, 1),
                                    15,
                                    null,
                                    BoxFit.fill,
                                    [
                                      textWidget(
                                        competitionProvider
                                            .comments[i].user.name,
                                        TextDirection.rtl,
                                        null,
                                        black,
                                        sizeFromWidth(context, 25),
                                        FontWeight.bold,
                                      ),
                                      textWidget(
                                        competitionProvider.comments[i].comment,
                                        TextDirection.rtl,
                                        null,
                                        black,
                                        sizeFromWidth(context, 30),
                                        FontWeight.bold,
                                      ),
                                    ],
                                    MainAxisAlignment.start,
                                    false,
                                    10,
                                    lightGrey,
                                    () {},
                                    CrossAxisAlignment.end),
                              ),
                              const SizedBox(width: 5),
                              storyShape(
                                context,
                                lightGrey,
                                competitionProvider.comments[i].user.image != ''
                                    ? NetworkImage(competitionProvider
                                        .comments[i].user.image)
                                    : null,
                                30,
                                33,
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
              if (!chatProvider.youtubePlayerController.value.isFullScreen)
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
          );
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(white, primaryColor),
          );
        },
      ),
    );
  }
}
