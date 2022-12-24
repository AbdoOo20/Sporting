// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/competitions/comments.dart';
import 'package:news/modules/show%20video/show%20video.dart';
import 'package:news/modules/show%20video/youtube%20video.dart';
import 'package:news/providers/competition%20provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'Competitions.dart';

class FansVote extends StatefulWidget {
  String docId;
  String date;
  bool end;

  FansVote(this.docId, this.date, this.end, {Key? key}) : super(key: key);

  @override
  State<FansVote> createState() => _FansVoteState();
}

class _FansVoteState extends State<FansVote> {
  late CompetitionProvider competitionProvider;

  @override
  void initState() {
    Provider.of<CompetitionProvider>(context, listen: false)
        .updateDate(widget.date);
    Provider.of<CompetitionProvider>(context, listen: false)
        .getCompetitionNumber(widget.docId);
    if (widget.end == true) {
      Provider.of<CompetitionProvider>(context, listen: false)
          .getGoldenMedal(widget.docId);
    }
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
            navigateAndFinish(context, const Competitions());
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: darkGrey,
            alignment: Alignment.center,
            width: sizeFromWidth(context, 1),
            child: Text(
              'عدد الأصوات المرشحة من الجماهير: ${competitionProvider.number}',
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('competition')
                            .doc(widget.docId)
                            .collection('users')
                            .orderBy('time', descending: false)
                            .snapshots(),
                        builder: (ctx, snapShot) {
                          if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: circularProgressIndicator(
                                    lightGrey, primaryColor));
                          }
                          var id = FirebaseAuth.instance.currentUser!.uid;
                          final doc = snapShot.data?.docs;
                          if (doc == null || doc.isEmpty) {
                            return const Center();
                          } else {
                            return GridView.builder(
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
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                              image: DecorationImage(
                                                image: NetworkImage(doc[index]
                                                        .id
                                                        .contains('image')
                                                    ? doc[index][
                                                        'pickedImageCompetitor']
                                                    : doc[index]['image']),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 5,
                                            top: 5,
                                            child: Container(
                                              width: sizeFromWidth(context, 15),
                                              height:
                                                  sizeFromWidth(context, 15),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      doc[index]['country']),
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
                                              height:
                                                  sizeFromWidth(context, 15),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      doc[index]['club']),
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
                                                  doc[index]['nameCompetitor'],
                                                  style: TextStyle(
                                                    height: 1.2,
                                                    fontSize: sizeFromWidth(
                                                        context, 25),
                                                    color: white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  doc[index]['position'],
                                                  style: TextStyle(
                                                    height: 1.2,
                                                    fontSize: sizeFromWidth(
                                                        context, 30),
                                                    color: white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (competitionProvider.greatScore ==
                                                  doc[index]['score'] &&
                                              widget.end == true)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
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
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20)),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7),
                                            child: Center(
                                              child: CircularPercentIndicator(
                                                radius:
                                                    sizeFromWidth(context, 15),
                                                percent: double.parse(doc[index]
                                                                ['score']
                                                            .toString()) >=
                                                        100
                                                    ? 100.0
                                                    : double.parse(doc[index]
                                                            ['score']
                                                        .toString()),
                                                backgroundColor:
                                                    const Color(0xFF202020),
                                                progressColor:
                                                    (competitionProvider
                                                                    .greatScore ==
                                                                doc[index]
                                                                    ['score'] &&
                                                            widget.end == true)
                                                        ? Colors.amber
                                                        : const Color(
                                                            0xFF035cd2),
                                                center: Text(
                                                  double.parse(doc[index]
                                                              ['score']
                                                          .toString())
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: sizeFromWidth(
                                                        context, 35),
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
                                                  if (doc[index]['video']
                                                      .toString()
                                                      .contains('youtu')) {
                                                    navigateTo(
                                                        context,
                                                        YoutubeVideo(doc[index]
                                                            ['video'], doc[index].id));
                                                  } else {
                                                    navigateTo(
                                                        context,
                                                        ShowVideo(doc[index]
                                                            ['video']));
                                                  }
                                                },
                                                icon: Icon(Icons.play_circle,
                                                    color: white)),
                                          ),
                                        ),
                                        if (!widget.end)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .all(const Color(
                                                                  0xFF39373a))),
                                                  onPressed: () async {
                                                    var data =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'competition')
                                                            .doc(widget.docId)
                                                            .collection('users')
                                                            .doc(doc[index].id)
                                                            .get();
                                                    List users = data['users'];
                                                    double score =
                                                        data['score'];
                                                    if (!users.contains(id)) {
                                                      users.add(id);
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'competition')
                                                          .doc(widget.docId)
                                                          .collection('users')
                                                          .doc(doc[index].id)
                                                          .update({
                                                        'users': users,
                                                        'score': (score + 0.01),
                                                      });
                                                      Provider.of<CompetitionProvider>(
                                                              context,
                                                              listen: false)
                                                          .getCompetitionNumber(
                                                              widget.docId);
                                                    } else {
                                                      showToast(
                                                          text:
                                                              'تم التصويت لهذا المتسابق',
                                                          state: ToastStates
                                                              .WARNING);
                                                    }
                                                  },
                                                  child: Text(
                                                    'أضف تصويت',
                                                    style: TextStyle(
                                                      color: white,
                                                      fontSize: sizeFromWidth(
                                                          context, 30),
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        MaterialStateProperty
                                                            .all(const Color(
                                                                0xFF39373a))),
                                                onPressed: () async {
                                                  var comments =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'competition')
                                                          .doc(widget.docId)
                                                          .collection('users')
                                                          .doc(doc[index].id)
                                                          .collection(
                                                              'comments')
                                                          .get();
                                                  navigateAndFinish(
                                                    context,
                                                    Comments(
                                                      widget.docId,
                                                      widget.date,
                                                      doc[index].id,
                                                      comments.docs.length,
                                                      widget.end,
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'تعليق',
                                                  style: TextStyle(
                                                    color: white,
                                                    fontSize: sizeFromWidth(
                                                        context, 30),
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
                              itemCount: doc.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 1 / 1.38,
                              ),
                            );
                          }
                        },
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
