// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news/modules/matches%20statistics/matches%20statistics.dart';

import '../../models/statistics/matches statistics.dart';
import '../../shared/Components.dart';
import '../../shared/const.dart';
import '../../shared/Style.dart';

class MatchDetails extends StatefulWidget {
  MatchesStatisticsModel matchesStatisticsModel;

  MatchDetails(this.matchesStatisticsModel, {Key? key}) : super(key: key);

  @override
  State<MatchDetails> createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const MatchesStatistics());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: sizeFromHeight(context, 4),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: sizeFromHeight(context, 8),
                            width: sizeFromHeight(context, 8),
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.matchesStatisticsModel.logo1),
                              ),
                            ),
                          ),
                          textWidget(
                            widget.matchesStatisticsModel.name1,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWidget(
                            widget.matchesStatisticsModel.scores.trim(),
                            TextDirection.rtl,
                            null,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                          if (widget.matchesStatisticsModel.haluh.trim() != 'تبدأ قريباً')
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: textWidget(
                                widget.matchesStatisticsModel.haluh.trim(),
                                TextDirection.rtl,
                                null,
                                primaryColor,
                                sizeFromWidth(context, 30),
                                FontWeight.bold,
                              ),
                            ),
                          if (widget.matchesStatisticsModel.haluh.trim() == 'تبدأ قريباً')
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: sizeFromHeight(context, 8),
                            width: sizeFromHeight(context, 8),
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      widget.matchesStatisticsModel.logo2)),
                            ),
                          ),
                          textWidget(
                            widget.matchesStatisticsModel.name2,
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  alignment: Alignment.center,
                  child: textWidget(
                    'معلومات اللقاء',
                    null,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                  ),
                ),
                itemsMatch(FontAwesomeIcons.award, 'البطولة', widget.matchesStatisticsModel.aldawriu, context),
                itemsMatch(FontAwesomeIcons.microphone, 'المعلق', widget.matchesStatisticsModel.muealaq, context),
                itemsMatch(FontAwesomeIcons.tv, 'القناة الناقلة ', widget.matchesStatisticsModel.qinah, context),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}

Widget itemsMatch(
  IconData? icon,
  String secondText,
  String firstText,
  BuildContext context,
) {
  return Container(
    decoration: BoxDecoration(
      color: lightGrey,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: primaryColor),
    ),
    margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          child: textWidget(
            firstText,
            null,
            TextAlign.center,
            primaryColor,
            sizeFromWidth(context, 20),
            FontWeight.bold,
          ),
        ),
        textWidget(
          secondText,
          null,
          null,
          darkGrey,
          sizeFromWidth(context, 25),
          FontWeight.bold,
        ),
        Icon(icon, color: primaryColor),
      ],
    ),
  );
}
