import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {

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
            Text(
              'IFMIS',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: sizeFromWidth(context, 23),
                color: white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(Icons.home, color: white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('members')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (ctx, snapShot) {
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
                          showModalBottomSheet(
                            context: context,
                            elevation: 0.001,
                            backgroundColor: primaryColor,
                            constraints: BoxConstraints(
                              maxWidth: sizeFromWidth(context, 1),
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: sizeFromWidth(context, 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: sizeFromWidth(context, 3),
                                      height: sizeFromWidth(context, 3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(doc[index]['person']),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: textWidget(
                                        doc[index]['name'],
                                        null,
                                        null,
                                        white,
                                        sizeFromWidth(context, 25),
                                        FontWeight.w400,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: sizeFromWidth(context, 10)),
                                      child: textWidget(
                                        doc[index]['about'],
                                        null,
                                        TextAlign.center,
                                        white,
                                        sizeFromWidth(context, 25),
                                        FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                      child: textWidget(
                                        doc[index]['country'],
                                        null,
                                        null,
                                        white,
                                        sizeFromWidth(context, 25),
                                        FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                      width: sizeFromWidth(context, 8),
                                      height: sizeFromWidth(context, 12),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(doc[index]['image']),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(5),
                          width: sizeFromWidth(context, 1),
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
                                    fontSize: sizeFromWidth(context, 20),
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                                ),
                              ),
                              SizedBox(width: sizeFromWidth(context, 10)),
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