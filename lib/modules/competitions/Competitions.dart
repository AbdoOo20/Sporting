import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/competitions/register%20competition.dart';
import 'package:news/modules/competitions/Fans_vote.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';
import 'package:intl/intl.dart' as intl;

class Competitions extends StatefulWidget {
  const Competitions({Key? key}) : super(key: key);

  @override
  State<Competitions> createState() => _CompetitionsState();
}

class _CompetitionsState extends State<Competitions> {
  String getState(String startTime, String endTime) {
    if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return 'لم تبدأ';
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0)) {
      return 'انتهت';
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays ==
            0)) {
      return 'جارى التنفيذ';
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return 'جارى التنفيذ';
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays ==
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return 'جارى التنفيذ';
    }
    return '';
  }

  String getDate(String endTime) {
    if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays >
        0)) {
      return 'سيتم إغلاق التصويت بتاريخ: ' '$endTime';
    } else if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays <
        0)) {
      return 'تم إغلاق التصويت بتاريخ: ' '$endTime';
    } else if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays ==
        0)) {
      return 'سيتم إغلاق التصويت اليوم';
    }
    return '';
  }

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
                  image: AssetImage('assets/images/icon.jpeg'),
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
                  .collection('competition')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (ctx, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          circularProgressIndicator(lightGrey, primaryColor));
                }
                var id = FirebaseAuth.instance.currentUser!.uid;
                final doc = snapShot.data?.docs;
                if (doc == null || doc.isEmpty) {
                  return const Center();
                } else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: doc.length,
                    itemBuilder: (ctx, index) {
                      List users = doc[index]['accept'];
                      return InkWell(
                        onTap: () {
                          List waitingUsers = doc[index]['waiting'];
                          List acceptUsers = doc[index]['accept'];
                          if (waitingUsers.contains(id) &&
                              (getState(doc[index]['startTime'],
                                          doc[index]['endTime']) ==
                                      'لم تبدأ' ||
                                  getState(doc[index]['startTime'],
                                          doc[index]['endTime']) ==
                                      'جارى التنفيذ') &&
                              doc[index]['state'] != 'خاصة') {
                            showToast(
                                text: 'انتظر حتى يتم قبولك بالمسابقة',
                                state: ToastStates.WARNING);
                          } else if (acceptUsers.contains(id) &&
                              (getState(doc[index]['startTime'],
                                          doc[index]['endTime']) ==
                                      'لم تبدأ' ||
                                  getState(doc[index]['startTime'],
                                          doc[index]['endTime']) ==
                                      'جارى التنفيذ') &&
                              doc[index]['state'] != 'خاصة') {
                            navigateAndFinish(
                                context,
                                FansVote(doc[index].id,
                                    getDate(doc[index]['endTime']),getState(doc[index]['startTime'],
                                        doc[index]['endTime']) ==
                                        'انتهت'));
                          } else if ((getState(doc[index]['startTime'],
                                          doc[index]['endTime']) ==
                                      'لم تبدأ' ||
                                  getState(doc[index]['startTime'],
                                          doc[index]['endTime']) ==
                                      'جارى التنفيذ') &&
                              !waitingUsers.contains(id) &&
                              !acceptUsers.contains(id) &&
                              doc[index]['state'] != 'خاصة') {
                            navigateAndFinish(
                                context, RegisterCompetition(doc[index].id));
                          } else if (doc[index]['state'] == 'خاصة') {
                            navigateAndFinish(
                                context,
                                FansVote(doc[index].id,
                                    getDate(doc[index]['endTime']),getState(doc[index]['startTime'],
                                        doc[index]['endTime']) ==
                                        'انتهت'));
                          } else {
                            showToast(
                                text: 'هذه المسابقة انتهت',
                                state: ToastStates.ERROR);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          width: sizeFromWidth(context, 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF7f0e14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                getState(doc[index]['startTime'],
                                    doc[index]['endTime']),
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 30),
                                  fontWeight: FontWeight.bold,
                                  color: getState(doc[index]['startTime'],
                                              doc[index]['endTime']) ==
                                          'انتهت'
                                      ? Colors.blue
                                      : getState(doc[index]['startTime'],
                                                  doc[index]['endTime']) ==
                                              'لم تبدأ'
                                          ? Colors.amber
                                          : Colors.green,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${doc[index]['name']} ${users.isNotEmpty ? '\n' : ''} ${users.isEmpty ? '' : 'عدد المشاركين: ${users.length}'}',
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
