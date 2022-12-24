// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:news/modules/profile/profile.dart';
import 'package:news/modules/show%20video/show%20video.dart';
import 'package:news/providers/chat%20provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/user provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../show image/show image.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String video;
  final bool isMe;
  final String image;
  final String userImage;
  final String audio;
  final int index;
  final String date;
  final String senderCountry;
  final String senderName;
  final String senderImage;
  String senderId;
  String chatId;
  String messageId;

  MessageBubble(
      this.message,
      this.isMe,
      this.image,
      this.audio,
      this.index,
      this.date,
      this.userImage,
      this.video,
      this.senderImage,
      this.senderName,
      this.senderCountry,
      this.senderId,
      this.chatId,
      this.messageId,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: Column(
        children: [
          if (image != '')
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe)
                  InkWell(
                    onTap: () {
                      showAlertDialog(context, senderName, senderImage,
                          senderCountry, senderId);
                    },
                    child: storyShape(
                      context,
                      white,
                      userImage == '' ? null : NetworkImage(userImage),
                      40,
                      35,
                    ),
                  ),
                if (isMe)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          FirebaseFirestore.instance
                              .collection('chatRoom')
                              .doc(chatId)
                              .collection('chats')
                              .doc(messageId)
                              .delete();
                          showToast(
                              text: 'تم حذف الصورة بنجاح',
                              state: ToastStates.SUCCESS);
                        },
                        child: Icon(Icons.delete, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        onTap: () async {
                          var url = Uri.parse(image);
                          var response = await http.get(url);
                          var bytes = response.bodyBytes;
                          var temp = await getTemporaryDirectory();
                          var path = '${temp.path}/image.jpg';
                          File(path).writeAsBytesSync(bytes);
                          await Share.shareFiles([path], text: image);
                        },
                        child: Icon(Icons.share, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        onTap: () async {
                          await GallerySaver.saveImage(image,
                                  albumName: 'صور الإتحاد الدولى')
                              .then((value) {
                            if (value!) {
                              showToast(
                                  text: 'تم حفظ الصورة بنجاح',
                                  state: ToastStates.SUCCESS);
                            }
                          });
                        },
                        child: Icon(Icons.download, color: primaryColor),
                      ),
                    ],
                  ),
                InkWell(
                  onTap: () {
                    navigateTo(context, ShowImage(image));
                  },
                  child: Container(
                    width: sizeFromWidth(context, 2.8),
                    height: sizeFromWidth(context, 2.8),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: !isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                        bottomRight: isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                ),
                if (!isMe)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          var url = Uri.parse(image);
                          var response = await http.get(url);
                          var bytes = response.bodyBytes;
                          var temp = await getTemporaryDirectory();
                          var path = '${temp.path}/image.jpg';
                          File(path).writeAsBytesSync(bytes);
                          await Share.shareFiles([path], text: image);
                        },
                        child: Icon(Icons.share, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 15)),
                      InkWell(
                        onTap: () async {
                          await GallerySaver.saveImage(image,
                              albumName: 'صور الإتحاد الدولى')
                              .then((value) {
                            if (value!) {
                              showToast(
                                  text: 'تم حفظ الصورة بنجاح',
                                  state: ToastStates.SUCCESS);
                            }
                          });
                        },
                        child: Icon(Icons.download, color: primaryColor),
                      ),
                    ],
                  ),
                if (isMe)
                  InkWell(
                    onTap: () {
                      showAlertDialog(context, senderName, senderImage,
                          senderCountry, senderId);
                    },
                    child: storyShape(
                      context,
                      white,
                      userImage == '' ? null : NetworkImage(userImage),
                      40,
                      35,
                    ),
                  ),
              ],
            ),
          if (message != '' &&
              !(message.contains('https') ||
                  message.contains('www') ||
                  message.contains('http')) &&
              !(message.contains('بمغادرة غرفة الدردشة') ||
                  message.contains('بالدخول للدردشة')))
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(context, senderName, senderImage,
                            senderCountry, senderId);
                      },
                      child: storyShape(
                        context,
                        white,
                        userImage == '' ? null : NetworkImage(userImage),
                        40,
                        35,
                      ),
                    ),
                  if (isMe)
                    InkWell(
                      onTap: () async {
                        FirebaseFirestore.instance
                            .collection('chatRoom')
                            .doc(chatId)
                            .collection('chats')
                            .doc(messageId)
                            .delete();
                        showToast(
                            text: 'تم حذف الرسالة بنجاح',
                            state: ToastStates.SUCCESS);
                      },
                      child: Icon(Icons.delete, color: primaryColor),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isMe ? darkGrey : lightGrey,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10),
                              topRight: const Radius.circular(10),
                              bottomLeft: !isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(10),
                              bottomRight: isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(10),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: '$message \n',
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.normal,
                                    color: isMe ? white : petroleum,
                                  )),
                              TextSpan(
                                text: date,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 45),
                                  fontWeight: FontWeight.normal,
                                  color: isMe ? white : petroleum,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(context, senderName, senderImage,
                            senderCountry, senderId);
                      },
                      child: storyShape(
                        context,
                        white,
                        userImage == '' ? null : NetworkImage(userImage),
                        40,
                        35,
                      ),
                    ),
                  SizedBox(width: sizeFromWidth(context, 80)),
                ],
              ),
            ),
          if (message != '' &&
              (message.contains('https') ||
                  message.contains('www') ||
                  message.contains('http')))
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(context, senderName, senderImage,
                            senderCountry, senderId);
                      },
                      child: storyShape(
                        context,
                        white,
                        userImage == '' ? null : NetworkImage(userImage),
                        40,
                        35,
                      ),
                    ),
                  if (isMe)
                    InkWell(
                      onTap: () async {
                        FirebaseFirestore.instance
                            .collection('chatRoom')
                            .doc(chatId)
                            .collection('chats')
                            .doc(messageId)
                            .delete();
                        showToast(
                            text: 'تم حذف الرسالة بنجاح',
                            state: ToastStates.SUCCESS);
                      },
                      child: Icon(Icons.delete, color: primaryColor),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isMe ? darkGrey : lightGrey,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10),
                              topRight: const Radius.circular(10),
                              bottomLeft: !isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(10),
                              bottomRight: isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(10),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () async {
                                  dynamic link = Uri.parse(message);
                                  try {
                                    await launchUrl(link);
                                  } catch (e) {
                                    showToast(
                                        text: 'there are error in link',
                                        state: ToastStates.ERROR);
                                  }
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      '$message \n',
                                      style: TextStyle(
                                        fontSize: sizeFromWidth(context, 30),
                                        fontWeight: FontWeight.w500,
                                        color: isMe ? white : petroleum,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: sizeFromWidth(context, 45),
                                  fontWeight: FontWeight.normal,
                                  color: isMe ? white : petroleum,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(context, senderName, senderImage,
                            senderCountry, senderId);
                      },
                      child: storyShape(
                        context,
                        white,
                        userImage == '' ? null : NetworkImage(userImage),
                        40,
                        35,
                      ),
                    ),
                  SizedBox(width: sizeFromWidth(context, 80)),
                ],
              ),
            ),
          if (message != '' &&
              (message.contains('بمغادرة غرفة الدردشة') ||
                  message.contains('بالدخول للدردشة')))
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: pink,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 5),
                    margin: const EdgeInsets.symmetric(
                        vertical: 2, horizontal: 8),
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(children: [
                        TextSpan(
                            text: '$message \n',
                            style: TextStyle(
                              fontSize: sizeFromWidth(context, 30),
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            )),
                        TextSpan(
                          text: date,
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 45),
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showAlertDialog(context, senderName, senderImage,
                          senderCountry, senderId);
                    },
                    child: storyShape(
                      context,
                      pink,
                      userImage == '' ? null : NetworkImage(userImage),
                      40,
                      35,
                    ),
                  ),
                ],
              ),
            ),
          if (audio != '')
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(context, senderName, senderImage,
                            senderCountry, senderId);
                      },
                      child: storyShape(
                        context,
                        white,
                        userImage == '' ? null : NetworkImage(userImage),
                        40,
                        35,
                      ),
                    ),
                  if (isMe)
                    InkWell(
                      onTap: () async {
                        FirebaseFirestore.instance
                            .collection('chatRoom')
                            .doc(chatId)
                            .collection('chats')
                            .doc(messageId)
                            .delete();
                        showToast(
                            text: 'تم حذف الرسالة الصوتية بنجاح',
                            state: ToastStates.SUCCESS);
                      },
                      child: Icon(Icons.delete, color: primaryColor),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: isMe ? darkGrey : lightGrey,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: !isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                        bottomRight: isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                      ),
                    ),
                    padding:
                        const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: sizeFromWidth(context, 1.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .getAudio(audio);
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .index = index;
                                },
                                child: Icon(
                                  Provider.of<ChatProvider>(context).index ==
                                          index
                                      ? Provider.of<ChatProvider>(context)
                                                  .isPlay ==
                                              false
                                          ? Icons.play_arrow_sharp
                                          : Icons.pause_circle_filled
                                      : Icons.play_arrow_sharp,
                                  color: primaryColor,
                                  size: sizeFromWidth(context, 10),
                                ),
                              ),
                              Slider.adaptive(
                                inactiveColor: isMe ? lightGrey : petroleum,
                                activeColor: primaryColor,
                                min: 0.0,
                                max: Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .duration
                                    .inSeconds
                                    .toDouble(),
                                value: Provider.of<ChatProvider>(context,
                                                listen: false)
                                            .index ==
                                        index
                                    ? Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .position
                                        .inSeconds
                                        .toDouble()
                                    : 0.0,
                                onChanged: (value) {
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .getSeek(value);
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: sizeFromWidth(context, 4.3),
                            right: sizeFromWidth(context, 17),
                          ),
                          width: sizeFromWidth(context, 1.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .isPlay &&
                                  Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .index ==
                                      index)
                                Text(
                                    Provider.of<ChatProvider>(context,
                                                    listen: false)
                                                .index ==
                                            index
                                        ? '${Provider.of<ChatProvider>(context, listen: false).position.inMinutes.remainder(60)}:${(Provider.of<ChatProvider>(context, listen: false).position.inSeconds.remainder(60))}'
                                        : '${Provider.of<ChatProvider>(context, listen: false).duration.inMinutes.remainder(60)}:${(Provider.of<ChatProvider>(context, listen: false).duration.inSeconds.remainder(60))}',
                                    style: TextStyle(
                                        color: isMe ? lightGrey : petroleum)),
                              if (!Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .isPlay ||
                                  Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .index !=
                                      index)
                                const Text(''),
                              Text(date,
                                  style: TextStyle(
                                      color: isMe ? lightGrey : petroleum)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMe)
                    InkWell(
                      onTap: () {
                        showAlertDialog(context, senderName, senderImage,
                            senderCountry, senderId);
                      },
                      child: storyShape(
                        context,
                        white,
                        userImage == '' ? null : NetworkImage(userImage),
                        40,
                        35,
                      ),
                    ),
                ],
              ),
            ),
          if (video != '')
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe)
                  InkWell(
                    onTap: () {
                      showAlertDialog(context, senderName, senderImage,
                          senderCountry, senderId);
                    },
                    child: storyShape(
                      context,
                      white,
                      userImage == '' ? null : NetworkImage(userImage),
                      40,
                      35,
                    ),
                  ),
                if (isMe)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          FirebaseFirestore.instance
                              .collection('chatRoom')
                              .doc(chatId)
                              .collection('chats')
                              .doc(messageId)
                              .delete();
                          showToast(
                              text: 'تم حذف الفيديو بنجاح',
                              state: ToastStates.SUCCESS);
                        },
                        child: Icon(Icons.delete, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        onTap: () async {
                          var url = Uri.parse(video);
                          var response = await http.get(url);
                          var bytes = response.bodyBytes;
                          var temp = await getTemporaryDirectory();
                          var path = '${temp.path}/video.mp4';
                          File(path).writeAsBytesSync(bytes);
                          await Share.shareFiles([path], text: video);
                        },
                        child: Icon(Icons.share, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 30)),
                      InkWell(
                        onTap: () async {
                          await GallerySaver.saveVideo(video,
                                  albumName: 'فيديوهات الإتحاد الدولى')
                              .then((value) {
                            if (value!) {
                              showToast(
                                  text: 'تم حفظ الفيديو بنجاح',
                                  state: ToastStates.SUCCESS);
                            }
                          });
                        },
                        child: Icon(Icons.download, color: primaryColor),
                      ),
                    ],
                  ),
                InkWell(
                  onTap: () {
                    navigateTo(context, ShowVideo(video));
                  },
                  child: Container(
                    width: sizeFromWidth(context, 2.8),
                    height: sizeFromWidth(context, 2.8),
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: !isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                        bottomRight: isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(10),
                      ),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      color: white,
                      size: sizeFromWidth(context, 8),
                    ),
                  ),
                ),
                if (!isMe)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          var url = Uri.parse(video);
                          var response = await http.get(url);
                          var bytes = response.bodyBytes;
                          var temp = await getTemporaryDirectory();
                          var path = '${temp.path}/video.mp4';
                          File(path).writeAsBytesSync(bytes);
                          await Share.shareFiles([path], text: video);
                        },
                        child: Icon(Icons.share, color: primaryColor),
                      ),
                      SizedBox(height: sizeFromHeight(context, 15)),
                      InkWell(
                        onTap: () async {
                          await GallerySaver.saveVideo(video,
                              albumName: 'فيديوهات الإتحاد الدولى')
                              .then((value) {
                            if (value!) {
                              showToast(
                                  text: 'تم حفظ الفيديو بنجاح',
                                  state: ToastStates.SUCCESS);
                            }
                          });
                        },
                        child: Icon(Icons.download, color: primaryColor),
                      ),
                    ],
                  ),
                if (isMe)
                  InkWell(
                    onTap: () {
                      showAlertDialog(context, senderName, senderImage,
                          senderCountry, senderId);
                    },
                    child: storyShape(
                      context,
                      white,
                      userImage == '' ? null : NetworkImage(userImage),
                      40,
                      35,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

showAlertDialog(
  BuildContext context,
  String name,
  String image,
  String country,
  String id,
) {
  AlertDialog alert = AlertDialog(
    backgroundColor: primaryColor,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: sizeFromHeight(context, 20),
          backgroundColor: primaryColor,
          backgroundImage: image != '' ? NetworkImage(image) : null,
        ),
        textWidget(
          name,
          null,
          TextAlign.center,
          white,
          sizeFromWidth(context, 25),
          FontWeight.bold,
        ),
        textWidget(
          country,
          null,
          TextAlign.center,
          white,
          sizeFromWidth(context, 30),
          FontWeight.bold,
        ),
        textButton(
          context,
          'عرض الملف الشخصى',
          primaryColor,
          white,
          sizeFromWidth(context, 30),
          FontWeight.bold,
          () {
            Provider.of<UserProvider>(context, listen: false).getUserData(id);
            navigateTo(context, Profile(id, 'chat'));
          },
        ),
      ],
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
