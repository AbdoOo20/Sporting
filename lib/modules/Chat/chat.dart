// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/chat%20provider.dart';
import 'package:provider/provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'Messages.dart';
import 'chats room.dart';
import 'newMessage.dart';

class Chat extends StatefulWidget {
  String id;
  String chatId;
  String categoryChatNumber;

  Chat(this.id, this.chatId, this.categoryChatNumber, {Key? key})
      : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late ChatProvider chatProvider;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).initPlayer();
    Provider.of<ChatProvider>(context, listen: false).initRecord();
    Provider.of<ChatProvider>(context, listen: false).isRecorderInitialised =
        true;
    super.initState();
  }

  void endChat(String endFrom) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    Provider.of<ChatProvider>(context, listen: false).audioPlayer.stop();
    Provider.of<ChatProvider>(context, listen: false).stopPlay();
    Provider.of<ChatProvider>(context, listen: false).killRecord();
    Provider.of<ChatProvider>(context, listen: false).disposePlayer();
    var usersInChat = await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatId)
        .get();
    List allUsers = usersInChat['users'];
    if (allUsers.contains(user)) {
      allUsers.remove(user);
    }
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatId)
        .update({
      'users': allUsers,
    });
    var currentUser =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    chatProvider.sendMessage(
      context,
      widget.id,
      widget.chatId,
      '${currentUser['userName']}\n قام بمغادرة غرفة الدردشة',
    );
    if (endFrom == 'inApp') {
      navigateAndFinish(context, ChatsRoom(widget.categoryChatNumber));
    }
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);

    return WillPopScope(
      onWillPop: () async {
        endChat('outApp');
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: textWidget(
            widget.id,
            null,
            null,
            white,
            sizeFromWidth(context, 25),
            FontWeight.w500,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false)
                  .getRoomUsers(widget.chatId);
              scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(Icons.people_alt, color: white),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                endChat('inApp');
              },
              icon: Icon(Icons.arrow_forward, color: white),
            ),
          ],
        ),
        drawer: SizedBox(
          width: sizeFromWidth(context, 5),
          child: Drawer(
            backgroundColor: primaryColor,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (Provider.of<ChatProvider>(context, listen: false)
                    .usersImage
                    .isEmpty) {
                  return const Center();
                }
                return Container(
                  padding: const EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundColor: scaffoldColor,
                    radius: sizeFromWidth(context, 13),
                    backgroundImage: Provider.of<ChatProvider>(context,
                                    listen: false)
                                .usersImage[index] !=
                            ''
                        ? NetworkImage(
                            Provider.of<ChatProvider>(context, listen: false)
                                .usersImage[index])
                        : null,
                  ),
                );
              },
              itemCount: Provider.of<ChatProvider>(context).usersImage.length,
            ),
          ),
        ),
        body: Container(
          height: sizeFromHeight(context, 1, hasAppBar: true),
          width: sizeFromWidth(context, 1),
          color: white,
          child: Column(
            children: [
              Expanded(child: Messages(widget.id, widget.chatId)),
              NewMessages(widget.id, widget.chatId),
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
                                  image:
                                      AssetImage('assets/images/banner2.png'),
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
        ),
      ),
    );
  }
}
