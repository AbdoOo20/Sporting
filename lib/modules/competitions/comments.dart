// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/competitions/Fans_vote.dart';
import 'package:news/providers/competition%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';

class Comments extends StatefulWidget {
  String competitionId;
  String userId;
  String date;
  int numberOfComments;
  bool end;

  Comments(this.competitionId, this.date, this.userId, this.numberOfComments, this.end, {Key? key})
      : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController comment = TextEditingController();
  late CompetitionProvider competitionProvider;

  String updateDate(String date) {
    if (date.contains('Jan')) {
      return date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '1,');
    } else if (date.contains('Feb')) {
      return date.replaceRange(date.indexOf('F'), date.indexOf('F') + 3, '2,');
    } else if (date.contains('Mar')) {
      return date.replaceRange(date.indexOf('M'), date.indexOf('M') + 3, '3,');
    } else if (date.contains('Apr')) {
      return date.replaceRange(date.indexOf('A'), date.indexOf('A') + 3, '4,');
    } else if (date.contains('May')) {
      return date.replaceRange(date.indexOf('M'), date.indexOf('M') + 3, '5,');
    } else if (date.contains('Jun')) {
      return date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '6,');
    } else if (date.contains('Jul')) {
      return date.replaceRange(date.indexOf('J'), date.indexOf('J') + 3, '7,');
    } else if (date.contains('Aug')) {
      return date.replaceRange(date.indexOf('A'), date.indexOf('A') + 3, '8,');
    } else if (date.contains('Sep')) {
      return date.replaceRange(date.indexOf('S'), date.indexOf('S') + 3, '9,');
    } else if (date.contains('Oct')) {
      return date.replaceRange(date.indexOf('O'), date.indexOf('O') + 3, '10,');
    } else if (date.contains('Nov')) {
      return date.replaceRange(date.indexOf('N'), date.indexOf('N') + 3, '11,');
    } else if (date.contains('Dec')) {
      return date.replaceRange(date.indexOf('D'), date.indexOf('D') + 3, '12,');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    competitionProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: Text(
          'التعليقات',
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: sizeFromWidth(context, 20),
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(
                context, FansVote(widget.competitionId, widget.date, widget.end));
          },
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        actions: [
          Center(
            child: Text(
              widget.numberOfComments.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: sizeFromWidth(context, 20),
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SizedBox(
        width: sizeFromWidth(context, 1),
        height: sizeFromHeight(context, 1),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('competition')
                    .doc(widget.competitionId)
                    .collection('users')
                    .doc(widget.userId)
                    .collection('comments')
                    .orderBy('time', descending: false)
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
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: materialWidget(
                                    context,
                                    null,
                                    sizeFromWidth(context, 1),
                                    15,
                                    null,
                                    BoxFit.fill,
                                    [
                                      textWidget(
                                        doc[index]['name'],
                                        TextDirection.rtl,
                                        null,
                                        black,
                                        sizeFromWidth(context, 25),
                                        FontWeight.bold,
                                      ),
                                      // textWidget(
                                      //   updateDate(doc[index]['dateTimePerDay']),
                                      //   TextDirection.rtl,
                                      //   null,
                                      //   black,
                                      //   sizeFromWidth(context, 45),
                                      //   FontWeight.bold,
                                      // ),
                                      // textWidget(
                                      //   doc[index]['dateTimePerHour'],
                                      //   TextDirection.ltr,
                                      //   null,
                                      //   black,
                                      //   sizeFromWidth(context, 45),
                                      //   FontWeight.bold,
                                      // ),
                                      textWidget(
                                        doc[index]['text'],
                                        TextDirection.rtl,
                                        null,
                                        black,
                                        sizeFromWidth(context, 30),
                                        FontWeight.bold,
                                      ),
                                    ],
                                    MainAxisAlignment.start,
                                    false,
                                    10,
                                    lightGrey,
                                    () {},
                                    CrossAxisAlignment.end),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  storyShape(context, lightGrey,
                                      NetworkImage(doc[index]['image']), 30, 33),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    height: sizeFromHeight(context, 10, hasAppBar: true),
                    child: textFormField(
                      controller: comment,
                      type: TextInputType.text,
                      validate: (value) {
                        return null;
                      },
                      hint: 'اكتب تعليق...',
                      isExpanded: true,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        if (comment.text == '') {
                          showToast(
                              text: 'يجب كتابة تعليق',
                              state: ToastStates.ERROR);
                        } else {
                          competitionProvider
                              .sendComment(widget.competitionId, widget.userId,
                                  comment.text.trim())
                              .then((value) {
                            comment.clear();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send_sharp,
                        size: sizeFromWidth(context, 15),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
