

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/matches%20statistics/statistics.dart';
import 'package:news/modules/matches%20statistics/match%20details.dart';
import 'package:news/providers/matches%20statistics%20provider.dart';
import 'package:provider/provider.dart';
import '../../shared/const.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class MatchesStatistics extends StatefulWidget {
  const MatchesStatistics({Key? key}) : super(key: key);

  @override
  State<MatchesStatistics> createState() => _MatchesStatisticsState();
}

class _MatchesStatisticsState extends State<MatchesStatistics> {
  late MatchesStatisticsProvider matchesStatisticsProvider;

  @override
  void initState() {
    Provider.of<MatchesStatisticsProvider>(context, listen: false)
        .getDateOfDay();
    Provider.of<MatchesStatisticsProvider>(context, listen: false).getMatches(
        Provider.of<MatchesStatisticsProvider>(context, listen: false).date);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                  ),
                  height: sizeFromHeight(context, 15),
                  alignment: Alignment.center,
                  child: textWidget(
                    matchesStatisticsProvider.getNameOfDay == ''
                        ? 'مباريات اليوم'
                        : 'مباريات ${matchesStatisticsProvider.getNameOfDay}',
                    null,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 20),
                    FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    matchesStatisticsProvider.selectDatePerDay(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                    ),
                    height: sizeFromHeight(context, 15),
                    alignment: Alignment.center,
                    child: textWidget(
                      matchesStatisticsProvider.date,
                      null,
                      null,
                      primaryColor,
                      sizeFromWidth(context, 20),
                      FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ConditionalBuilder(
            condition: matchesStatisticsProvider.matches.isNotEmpty,
            builder: (context) {
              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = matchesStatisticsProvider.matches;
                    return InkWell(
                      onTap: () {
                        navigateAndFinish(context, MatchDetails(data[index]));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: sizeFromHeight(context, 18),
                                  width: sizeFromHeight(context, 18),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(data[index].logo1),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: sizeFromHeight(context, 10),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: textWidget(
                                    data[index].name1,
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                    null,1
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                textWidget(
                                  data[index].scores,
                                  TextDirection.rtl,
                                  null,
                                  white,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                                if (data[index].haluh.trim() != 'تبدأ قريباً')
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: textWidget(
                                      data[index].haluh,
                                      TextDirection.rtl,
                                      null,
                                      primaryColor,
                                      sizeFromWidth(context, 30),
                                      FontWeight.bold,
                                    ),
                                  ),
                                if (data[index].haluh.trim() == 'تبدأ قريباً')
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: textWidget(
                                      'تبدأ قريبا',
                                      TextDirection.rtl,
                                      null,
                                      primaryColor,
                                      sizeFromWidth(context, 30),
                                      FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: sizeFromHeight(context, 18),
                                  width: sizeFromHeight(context, 18),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(data[index].logo2)),
                                  ),
                                ),
                                Container(
                                  width: sizeFromHeight(context, 10),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: textWidget(
                                    data[index].name2,
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold, null,1
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: matchesStatisticsProvider.matches.length,
                ),
              );
            },
            fallback: (context) {
              return Expanded(
                  child: Center(
                      child:
                          circularProgressIndicator(lightGrey, primaryColor, context)));
            },
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
