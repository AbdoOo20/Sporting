// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/matches%20statistics/league.dart';
import 'package:provider/provider.dart';

import '../../providers/matches statistics provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class Teams extends StatefulWidget {
  String champion;

  Teams(this.champion, {Key? key}) : super(key: key);

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  late MatchesStatisticsProvider matchesStatisticsProvider;

  @override
  void initState() {
    Provider.of<MatchesStatisticsProvider>(context, listen: false)
        .getTeams(widget.champion);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    matchesStatisticsProvider = Provider.of(context);
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
            navigateAndFinish(context, const League());
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'نقاط',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 40),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: sizeFromWidth(context, 15)),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'أهداف',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 40),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: sizeFromWidth(context, 150)),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'خ',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 40),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: sizeFromWidth(context, 25)),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'ت',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 40),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: sizeFromWidth(context, 250)),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'ف',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 40),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'لعب',
                    TextDirection.rtl,
                    null,
                    white,
                    sizeFromWidth(context, 40),
                    FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: sizeFromWidth(context, 25)),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'الفريق',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 40),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'ت',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 40),
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ConditionalBuilder(
            condition: matchesStatisticsProvider.teams.isNotEmpty,
            builder: (context) {
              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = matchesStatisticsProvider.teams;
                    return Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textWidget(
                            data[index].pts == null
                                ? 0.toString()
                                : data[index].pts.toString(),
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 40),
                            FontWeight.bold,
                          ),
                          textWidget(
                            data[index].diff,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 40),
                            FontWeight.bold,
                          ),
                          textWidget(
                            data[index].goalPlusMinus,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 40),
                            FontWeight.bold,
                          ),
                          textWidget(
                            data[index].matchLeft,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 40),
                            FontWeight.bold,
                          ),
                          textWidget(
                            data[index].lost,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 40),
                            FontWeight.bold,
                          ),
                          textWidget(
                            data[index].draw,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 40),
                            FontWeight.bold,
                          ),
                          textWidget(
                            data[index].won,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 40),
                            FontWeight.bold,
                          ),
                          textWidget(
                            data[index].pld,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 40),
                            FontWeight.bold,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: sizeFromWidth(context, 5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                            ),
                            alignment: Alignment.centerRight,
                            child: textWidget(
                                data[index].team.trim(),
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.bold,
                                null,
                                1),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              image: DecorationImage(
                                image: NetworkImage(data[index].teamLogo),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: white,
                            ),
                            child: textWidget(
                              data[index].rank,
                              null,
                              null,
                              primaryColor,
                              sizeFromWidth(context, 30),
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: matchesStatisticsProvider.teams.length,
                ),
              );
            },
            fallback: (context) {
              return Expanded(
                  child: Center(
                      child:
                          circularProgressIndicator(lightGrey, primaryColor)));
            },
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
    );
  }
}
