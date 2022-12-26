// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:news/network/cash_helper.dart';
import 'package:news/providers/chat%20provider.dart';
import 'package:news/shared/Components.dart';
import 'package:news/shared/Style.dart';
import 'package:provider/provider.dart';
import 'MessageBubble.dart';

class Messages extends StatelessWidget {
  String chatId;

  Messages(this.chatId, {Key? key}) : super(key: key);

  late ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    return StreamBuilder(
      stream: chatProvider.stream,
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: circularProgressIndicator(lightGrey, primaryColor));
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemCount: chatProvider.messages.length,
          itemBuilder: (ctx, index) {
            var id = CacheHelper.getData(key: 'id');
            return MessageBubble(
              chatProvider.messages[index],
              chatProvider.messages[index].user.id == id,
            );
          },
        );
      },
    );
  }
}
