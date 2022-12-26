import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/matches%20statistics/statistics.dart';
import 'package:news/modules/show%20video/youtube%20video.dart';
import '../../shared/const.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../show video/show video.dart';

class MatchesSummary extends StatefulWidget {
  const MatchesSummary({Key? key}) : super(key: key);

  @override
  State<MatchesSummary> createState() => _MatchesSummaryState();
}

class _MatchesSummaryState extends State<MatchesSummary> {
  @override
  Widget build(BuildContext context) {
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
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const Statistics());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('matches')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (ctx, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          circularProgressIndicator(lightGrey, primaryColor));
                }
                final doc = snapShot.data?.docs;
                if (doc == null || doc.isEmpty) {
                  return const Center();
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 15, right: 15),
                          decoration: const BoxDecoration(
                            color: Color(0xFF151515),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: sizeFromWidth(context, 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF39373a),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(doc[index]['image']),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        log(doc[index]['link']);
                                        if (doc[index]['link']
                                                .toString()
                                                .contains('youtube') ||
                                            doc[index]['link']
                                                .toString()
                                                .contains('youtu.be')) {
                                          navigateTo(context,
                                              YoutubeVideo(doc[index]['link'],doc[index]['name']));
                                        } else {
                                          navigateTo(context,
                                              ShowVideo(doc[index]['link']));
                                        }
                                      },
                                      icon: Icon(Icons.play_circle,
                                          color: white)),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  doc[index]['name'],
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontSize: sizeFromWidth(context, 30),
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: doc.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1 / 1,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
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
    );
  }
}
