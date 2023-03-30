import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/matches%20statistics/champions%20scores.dart';
import 'package:news/modules/matches%20statistics/league.dart';
import 'package:news/modules/matches%20statistics/matches%20statistics.dart';
import 'package:news/modules/matches%20statistics/matches%20summary.dart';
import 'package:news/modules/matches%20statistics/players.dart';
import '../../providers/matches statistics provider.dart';
import '../../shared/const.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../articles/articles.dart';
import '../home/home.dart';
import 'package:provider/provider.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late MatchesStatisticsProvider matchesStatisticsProvider;

  @override
  Widget build(BuildContext context) {
    matchesStatisticsProvider = Provider.of(context);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                InkWell(
                  onTap: () async {
                    if (settingModel.value == 'open') {
                      navigateAndFinish(context, const Articles());
                    } else {
                      showToast(
                          text: 'جاري العمل عليها', state: ToastStates.SUCCESS);
                    }
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
                            'الأخبار الرياضية المتنوعة',
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
                          height: sizeFromHeight(context, 12, hasAppBar: true),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/17.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (settingModel.value == 'open') {
                      navigateAndFinish(context, const PlayersTransaction());
                    } else {
                      showToast(
                          text: 'جاري العمل عليها', state: ToastStates.SUCCESS);
                    }
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
                            'انتقالات لاعبين كرة القدم',
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
                          height: sizeFromHeight(context, 12, hasAppBar: true),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/16.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (settingModel.value == 'open') {
                      navigateAndFinish(context, const MatchesStatistics());
                    } else {
                      showToast(
                          text: 'جاري العمل عليها', state: ToastStates.SUCCESS);
                    }
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
                            'جدول مباريات كرة القدم',
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
                          height: sizeFromHeight(context, 12, hasAppBar: true),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/14.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (settingModel.value == 'open') {
                      navigateAndFinish(context, const ChampionsScores());
                    } else {
                      showToast(
                          text: 'جاري العمل عليها', state: ToastStates.SUCCESS);
                    }
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
                            'ترتيب هدافين كرة القدم',
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
                          height: sizeFromHeight(context, 12, hasAppBar: true),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/12.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (settingModel.value == 'open') {
                      navigateAndFinish(context, const League());
                    } else {
                      showToast(
                          text: 'جاري العمل عليها', state: ToastStates.SUCCESS);
                    }
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
                            'ترتيب نتائج مباريات كرة القدم',
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
                          height: sizeFromHeight(context, 12, hasAppBar: true),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/15.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (settingModel.value == 'open') {
                      navigateAndFinish(context, const MatchesSummary());
                    } else {
                      showToast(
                          text: 'جاري العمل عليها', state: ToastStates.SUCCESS);
                    }
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
                            'ملخصات مباريات كرة القدم',
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
                          height: sizeFromHeight(context, 12, hasAppBar: true),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage('assets/images/13.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
