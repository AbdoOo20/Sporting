import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../home/home.dart';

class ChampionshipStats extends StatefulWidget {
  const ChampionshipStats({Key? key}) : super(key: key);

  @override
  State<ChampionshipStats> createState() => _ChampionshipStatsState();
}

class _ChampionshipStatsState extends State<ChampionshipStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
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
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(
            Icons.home,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('champion')
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
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: doc.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () async {
                          var url = Uri.parse(doc[index]['link']);
                          await launchUrl(url, mode: LaunchMode.inAppWebView);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          width: sizeFromWidth(context, 1),
                          height: sizeFromHeight(context, 10, hasAppBar: true),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF7f0e14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  doc[index]['name'],
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: sizeFromWidth(context, 7),
                                height: sizeFromHeight(context, 12,
                                    hasAppBar: true),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(doc[index]['image']),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
