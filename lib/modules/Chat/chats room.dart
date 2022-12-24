// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/Chat/category%20chat.dart';
import 'package:news/modules/Chat/chat.dart';
import 'package:provider/provider.dart';
import '../../providers/chat provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class ChatsRoom extends StatefulWidget {
  String categoryChatNumber;

  ChatsRoom(this.categoryChatNumber, {Key? key}) : super(key: key);

  @override
  State<ChatsRoom> createState() => _ChatsRoomState();
}

class _ChatsRoomState extends State<ChatsRoom> {
  late ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
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
              padding: EdgeInsets.all(sizeFromWidth(context, 20)),
              margin: const EdgeInsets.all(5),
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
            navigateAndFinish(context, const CategoryChat());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRoom')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (ctx, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          circularProgressIndicator(lightGrey, primaryColor));
                }
                final doc = snapShot.data?.docs;
                var user = FirebaseAuth.instance.currentUser!.uid;
                if (doc == null || doc.isEmpty) {
                  return const Center();
                } else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: doc.length,
                    itemBuilder: (ctx, index) {
                      List allUsers = doc[index]['users'];
                      if (doc[index]['categoryNumber'] ==
                          widget.categoryChatNumber) {
                        return InkWell(
                          onTap: () async {
                            var usersInChat = await FirebaseFirestore.instance
                                .collection('chatRoom')
                                .doc(doc[index]['chatId'])
                                .get();
                            List allUsers = usersInChat['users'];
                            int numbers = usersInChat['numbers'];
                            if (allUsers.length == numbers) {
                              showToast(
                                  text: 'هذه الغرفة ممتلئة بالمستخدمين',
                                  state: ToastStates.ERROR);
                            } else {
                              if (!allUsers.contains(user)) {
                                allUsers.add(user);
                              }
                              FirebaseFirestore.instance
                                  .collection('chatRoom')
                                  .doc(doc[index]['chatId'])
                                  .update({
                                'users': allUsers,
                              });
                              var currentUser = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user)
                                  .get();
                              chatProvider.sendMessage(
                                context,
                                doc[index]['name'],
                                doc[index]['chatId'],
                                '${currentUser['userName']} \n قام بالدخول للدردشة',
                              );
                              navigateAndFinish(
                                  context,
                                  Chat(doc[index]['name'], doc[index]['chatId'],
                                      widget.categoryChatNumber));
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        doc[index]['name'],
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: sizeFromWidth(context, 30),
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                        ),
                                      ),
                                      Text(
                                        'مستخدمين الغرفة: ${doc[index]['numbers']}',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: sizeFromWidth(context, 30),
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                        ),
                                      ),
                                      Text(
                                        'الموجودون حاليا: ${allUsers.length.toString()}',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: sizeFromWidth(context, 30),
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                        ),
                                      ),
                                    ],
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
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
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
