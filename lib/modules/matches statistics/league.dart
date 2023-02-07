import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/matches%20statistics/statistics.dart';
import 'package:news/modules/matches%20statistics/teams.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class League extends StatefulWidget {
  const League({Key? key}) : super(key: key);

  @override
  State<League> createState() => _LeagueState();
}

class _LeagueState extends State<League> {
  DateTime now = DateTime.now();

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
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                itemCard('كأس العالم', '${now.year - 1}-world-cup/'),
                itemCard('الدورى السعودى الممتاز',
                    '${now.year - 1}-${now.year}-saudi-league/'),
                itemCard('دورى أبطال أوروبا',
                    '${now.year - 1}-${now.year}-uefa-champions-league/'),
                itemCard('الدورى الأوروبى',
                    '${now.year - 1}-${now.year}-uefa-europa-league/'),
                itemCard('الدورى الإنجليزى',
                    '${now.year - 1}-${now.year}-england-premier-league/'),
                itemCard('الدورى الأسبانى',
                    '${now.year - 1}-${now.year}-spanish-primera-division/'),
                itemCard('الدورى الفرنسى',
                    '${now.year - 1}-${now.year}-french-ligue-1/'),
                itemCard('الدورى الألمانى',
                    '${now.year - 1}-${now.year}-german-bundesliga/'),
                itemCard('الدورى الإيطالى',
                    '${now.year - 1}-${now.year}-italian-league-serie-a/'),
                itemCard('كأس آمم أفريقيا',
                    '${now.year - 1}-africa-cup-of-nations/'),
                itemCard('دورى الأمم الأوروبية',
                    '${now.year - 1}-${now.year}-uefa-nations-league/'),
                itemCard('كأس العرب', '2021-arab-cup/'),
                itemCard('الدورى المصرى',
                    '${now.year - 1}-${now.year}-egyptian-premier-league/'),
                itemCard('الدورى السعودى للشباب',
                    '${now.year - 1}-${now.year}-saudi-youth-league/'),
                itemCard('دورى أبطال أفريقيا',
                    '${now.year - 1}-${now.year}-caf-champions-league/'),
                itemCard('الدورى العراقى',
                    '${now.year - 1}-${now.year}-iraqi-premier-league/'),
                itemCard('الدورى الجزائرى',
                    '${now.year - 1}-${now.year}-algerian-ligue-1/'),
                itemCard('الدورى التونسى',
                    '${now.year - 1}-${now.year}-tunisian-ligue-1/'),
                itemCard('الدورى الأردنى',
                    '${now.year - 1}-${now.year}-jordanian-pro-league/'),
                itemCard('الدورى القطرى',
                    '${now.year - 1}-${now.year}-qatari-league/'),
                itemCard('الدورى التركى',
                    '${now.year - 1}-${now.year}-turkish-super-lig/'),
                itemCard('الدورى المغربى',
                    '${now.year - 1}-${now.year}-moroccan-league-botola/'),
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

  Widget itemCard(String title, String champion) {
    return InkWell(
      onTap: () {
        navigateAndFinish(context, Teams(champion));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            textWidget(
              title,
              null,
              null,
              white,
              sizeFromWidth(context, 20),
              FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
