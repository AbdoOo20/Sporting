// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'MessageBubble.dart';

class Messages extends StatelessWidget {
  String id;
  String chatId;

  Messages(this.id, this.chatId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatId)
          .collection('chats')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (ctx, snapShot) {
        final doc = snapShot.data?.docs;
        final user = FirebaseAuth.instance.currentUser?.uid;
        if (doc == null || doc.isEmpty) {
          return const Center();
        } else {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            itemCount: doc.length,
            itemBuilder: (ctx, index) {
              if ((id == doc[index]['receiver'])) {
                return MessageBubble(
                  doc[index]['text'],
                  doc[index]['sender'] == user,
                  doc[index]['image'] == '' ? '' : doc[index]['image'],
                  doc[index]['audio'] == '' ? '' : doc[index]['audio'],
                  doc[index].hashCode,
                  doc[index]['timeOfDay'],
                  doc[index]['senderImage'],
                  doc[index]['video'],
                  doc[index]['senderImage'],
                  doc[index]['senderName'],
                  doc[index]['senderCountry'],
                  doc[index]['sender'],
                  chatId,
                  doc[index].id,
                );
              } else {
                return const SizedBox();
              }
            },
          );
        }
      },
    );
  }
}
