// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/show%20video/comment%20video.dart';
import 'package:news/providers/chat%20provider.dart';
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
  String title;

  YoutubeVideo(this.videoLink, this.title, {Key? key}) : super(key: key);

  @override
  State<YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  late ChatProvider chatProvider;
  late OtherProvider otherProvider;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    otherProvider = Provider.of(context);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!chatProvider.youtubePlayerController.value.isFullScreen)
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('commentVideo')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (ctx, snapShot) {
                      final doc = snapShot.data?.docs;
                      if (doc == null || doc.isEmpty) {
                        return const Center();
                      } else {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: doc.length,
                          itemBuilder: (ctx, index) {
                            if(index == 0) {
                              return Column(
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
                                            onTap: () async{
                                              var url = Uri.parse(widget.videoLink);
                                              await launchUrl(url, mode: LaunchMode.inAppWebView);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                                          child: InkWell(
                                            onTap: () {
                                              String email =
                                                  CacheHelper.getData(key: 'email') ?? '';
                                              if (email == '') {
                                                showAlertDialog(context);
                                              } else {
                                                navigateTo(context, CommentVideo(widget.title));
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                        ),
                                      ],
                                    ),
                                  // if (doc[index]['title'] == widget.title)
                                  //   Container(
                                  //     padding: const EdgeInsets.all(5),
                                  //     margin: const EdgeInsets.all(5),
                                  //     width: sizeFromWidth(context, 1),
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(10),
                                  //       color: const Color(0xFF7f0e14),
                                  //     ),
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.end,
                                  //       children: [
                                  //         if (currentUser == doc[index]['id'])
                                  //           IconButton(
                                  //               onPressed: () {
                                  //                 otherProvider
                                  //                     .deleteComment(doc[index].id);
                                  //               },
                                  //               icon:
                                  //               Icon(Icons.delete, color: white)),
                                  //         Expanded(
                                  //           child: Column(
                                  //             crossAxisAlignment:
                                  //             CrossAxisAlignment.end,
                                  //             children: [
                                  //               Text(
                                  //                 doc[index]['name'],
                                  //                 textDirection: TextDirection.rtl,
                                  //                 style: TextStyle(
                                  //                   fontSize:
                                  //                   sizeFromWidth(context, 25),
                                  //                   fontWeight: FontWeight.bold,
                                  //                   color: white,
                                  //                 ),
                                  //               ),
                                  //               Text(
                                  //                 doc[index]['comment'],
                                  //                 textDirection: TextDirection.rtl,
                                  //                 style: TextStyle(
                                  //                   fontSize:
                                  //                   sizeFromWidth(context, 30),
                                  //                   fontWeight: FontWeight.bold,
                                  //                   color: white,
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //         const SizedBox(width: 5),
                                  //         if (doc[index]['image'] != '')
                                  //           Container(
                                  //             width: sizeFromWidth(context, 7),
                                  //             height: sizeFromHeight(context, 12,
                                  //                 hasAppBar: true),
                                  //             decoration: BoxDecoration(
                                  //               color: white,
                                  //               borderRadius:
                                  //               BorderRadius.circular(10),
                                  //               image: DecorationImage(
                                  //                   image: NetworkImage(
                                  //                       doc[index]['image']),
                                  //                   fit: BoxFit.cover),
                                  //             ),
                                  //           ),
                                  //       ],
                                  //     ),
                                  //   ),
                                ],
                              );
                            }
                            // if (doc[index]['title'] == widget.title) {
                            //   return Container(
                            //     padding: const EdgeInsets.all(5),
                            //     margin: const EdgeInsets.all(5),
                            //     width: sizeFromWidth(context, 1),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //       color: const Color(0xFF7f0e14),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.end,
                            //       children: [
                            //         if (currentUser == doc[index]['id'])
                            //           IconButton(
                            //               onPressed: () {
                            //                 otherProvider
                            //                     .deleteComment(doc[index].id);
                            //               },
                            //               icon:
                            //                   Icon(Icons.delete, color: white)),
                            //         Expanded(
                            //           child: Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.end,
                            //             children: [
                            //               Text(
                            //                 doc[index]['name'],
                            //                 textDirection: TextDirection.rtl,
                            //                 style: TextStyle(
                            //                   fontSize:
                            //                       sizeFromWidth(context, 25),
                            //                   fontWeight: FontWeight.bold,
                            //                   color: white,
                            //                 ),
                            //               ),
                            //               Text(
                            //                 doc[index]['comment'],
                            //                 textDirection: TextDirection.rtl,
                            //                 style: TextStyle(
                            //                   fontSize:
                            //                       sizeFromWidth(context, 30),
                            //                   fontWeight: FontWeight.bold,
                            //                   color: white,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         const SizedBox(width: 5),
                            //         if (doc[index]['image'] != '')
                            //           Container(
                            //             width: sizeFromWidth(context, 7),
                            //             height: sizeFromHeight(context, 12,
                            //                 hasAppBar: true),
                            //             decoration: BoxDecoration(
                            //               color: white,
                            //               borderRadius:
                            //                   BorderRadius.circular(10),
                            //               image: DecorationImage(
                            //                   image: NetworkImage(
                            //                       doc[index]['image']),
                            //                   fit: BoxFit.cover),
                            //             ),
                            //           ),
                            //       ],
                            //     ),
                            //   );
                            // }
                            return const SizedBox();
                          },
                        );
                      }
                    },
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
