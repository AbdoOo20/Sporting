// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news/modules/competitions/register%20competition.dart';
import 'package:news/modules/show%20video/show%20video.dart';
import 'package:news/modules/show%20video/youtube%20video.dart';
import 'package:news/providers/competition%20provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../models/competition/competition model.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'Competitions.dart';
import 'comments.dart';

class FansVote extends StatefulWidget {
  CompetitionModel competitionModel;
  String endDate;
  bool isEnd;

  FansVote(this.competitionModel, this.endDate, this.isEnd, {Key? key})
      : super(key: key);

  @override
  State<FansVote> createState() => _FansVoteState();
}

class _FansVoteState extends State<FansVote> {
  late CompetitionProvider competitionProvider;

  @override
  void initState() {
    Provider.of<CompetitionProvider>(context, listen: false)
        .getAllCompetitors(widget.competitionModel.id)
        .then((value) {
      if (widget.isEnd == true) {
        Provider.of<CompetitionProvider>(context, listen: false)
            .getGoldenMedal();
      }
    });
    Provider.of<CompetitionProvider>(context, listen: false)
        .updateDate(widget.endDate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    competitionProvider = Provider.of(context);
    return Scaffold(
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
            navigateAndFinish(context, const Competitions());
          },
        ),
        actions: [
          if (widget.competitionModel.type == 'public')
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                navigateTo(
                    context, RegisterCompetition(widget.competitionModel.id));
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: darkGrey,
            alignment: Alignment.center,
            width: sizeFromWidth(context, 1),
            child: Text(
              'عدد الأصوات المرشحة من الجماهير: ${widget.competitionModel.numberVotes}',
              style: TextStyle(
                fontSize: sizeFromWidth(context, 25),
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
          Container(
            color: const Color(0xFF7f0e14),
            width: sizeFromWidth(context, 1),
            alignment: Alignment.center,
            height: sizeFromHeight(context, 20, hasAppBar: true),
            child: Text(
              competitionProvider.dateAfterEdit,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: sizeFromWidth(context, 25),
                color: white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: darkGrey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return FlipCard(
                            front: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: sizeFromWidth(context, 2.5),
                                      height: sizeFromHeight(context, 5.5,
                                          hasAppBar: true),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xFF373a41),
                                              Color(0xFF484b50),
                                            ]),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              competitionProvider
                                                  .competitors[index].image),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 5,
                                      top: 5,
                                      child: Container(
                                        width: sizeFromWidth(context, 15),
                                        height: sizeFromWidth(context, 15),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                competitionProvider
                                                    .competitors[index]
                                                    .countryImage),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: Container(
                                        width: sizeFromWidth(context, 15),
                                        height: sizeFromWidth(context, 15),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/logo 2.jpeg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                      color: const Color(0xFF1e1e1e),
                                      width: sizeFromWidth(context, 2.5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            competitionProvider
                                                .competitors[index].name,
                                            style: TextStyle(
                                              height: 1.2,
                                              fontSize:
                                                  sizeFromWidth(context, 25),
                                              color: white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            competitionProvider
                                                .competitors[index].center,
                                            style: TextStyle(
                                              height: 1.2,
                                              fontSize:
                                                  sizeFromWidth(context, 30),
                                              color: white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (competitionProvider.score ==
                                            double.parse(competitionProvider
                                                .competitors[index].score) &&
                                        widget.isEnd == true)
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Icon(
                                            FontAwesomeIcons.medal,
                                            color: Colors.amber),
                                      ),
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: sizeFromWidth(context, 2.5),
                                      height: sizeFromHeight(context, 10,
                                          hasAppBar: true),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF151515),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
                                      child: Center(
                                        child: CircularPercentIndicator(
                                          radius: sizeFromWidth(context, 15),
                                          percent: double.parse(
                                                      competitionProvider
                                                          .competitors[index]
                                                          .score) >=
                                                  100.0
                                              ? 1.0
                                              : (double.parse(double.parse(
                                                          competitionProvider
                                                              .competitors[
                                                                  index]
                                                              .score)
                                                      .toStringAsFixed(2)) /
                                                  1000),
                                          backgroundColor:
                                              const Color(0xFF202020),
                                          progressColor: (competitionProvider
                                                          .score ==
                                                      double.parse(
                                                          competitionProvider
                                                              .competitors[
                                                                  index]
                                                              .score) &&
                                                  widget.isEnd == true
                                              ? Colors.amber
                                              : const Color(0xFF035cd2)),
                                          center: Text(
                                            double.parse((double.parse(
                                                            competitionProvider
                                                                .competitors[
                                                                    index]
                                                                .score) *
                                                        100)
                                                    .toStringAsFixed(0))
                                                .toString(),
                                            style: TextStyle(
                                              fontSize:
                                                  sizeFromWidth(context, 35),
                                              color: white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: Icon(Icons.restart_alt,
                                          color: Color(0xFF9f9f9f)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            back: Container(
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
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF39373a),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            if (competitionProvider
                                                .competitors[index].videoLink
                                                .contains('youtube')) {
                                              navigateTo(
                                                  context,
                                                  YoutubeVideo(
                                                      competitionProvider
                                                          .competitors[index]
                                                          .videoLink,
                                                      'competition', competitionProvider
                                                      .competitors[index].id));
                                            } else {
                                              navigateTo(
                                                  context,
                                                  ShowVideo(competitionProvider
                                                      .competitors[index]
                                                      .videoLink));
                                            }
                                          },
                                          icon: Icon(Icons.play_circle,
                                              color: white)),
                                    ),
                                  ),
                                  if(!widget.isEnd)
                                    Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xFF39373a))),
                                          onPressed: () async {
                                            competitionProvider.addVote(
                                                widget.competitionModel.id,
                                                competitionProvider
                                                    .competitors[index].id);
                                          },
                                          child: Text(
                                            'أضف تصويت',
                                            style: TextStyle(
                                              color: white,
                                              fontSize:
                                                  sizeFromWidth(context, 30),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xFF39373a))),
                                          onPressed: () async {
                                            navigateAndFinish(
                                              context,
                                              Comments(
                                                widget.competitionModel,
                                                widget.endDate,
                                                competitionProvider
                                                    .competitors[index].id,
                                                competitionProvider
                                                    .competitors[index]
                                                    .numberComments,
                                                widget.isEnd,
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'تعليق',
                                            style: TextStyle(
                                              color: white,
                                              fontSize:
                                                  sizeFromWidth(context, 30),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      SizedBox(width: 10),
                                      Icon(Icons.restart_alt,
                                          color: Color(0xFF9f9f9f)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: competitionProvider.competitors.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1 / 1.35,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: sizeFromHeight(context, 50, hasAppBar: true))
                  ],
                ),
              ),
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
