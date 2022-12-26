// ignore_for_file: must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:news/providers/chat%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';

class NewMessages extends StatefulWidget {
  String chatId;

  NewMessages(this.chatId, {Key? key}) : super(key: key);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  late ChatProvider chatProvider;

  showAlertDialog(BuildContext context) {
    Widget cancelButton = textButton(
      context,
      'اختر صورة',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
          () {
            chatProvider.sendMessage(widget.chatId, '', 'image');
      },
    );
    Widget continueButton = textButton(
      context,
      'اختر فيديو',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
          () {
            chatProvider.sendMessage(widget.chatId, '', 'video');
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        'قم بالاختيار من معرض الصور',
        null,
        TextAlign.center,
        primaryColor,
        sizeFromWidth(context, 20),
        FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: continueButton),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: cancelButton),
            ],
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

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of(context);
    return Container(
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: lightGrey, size: 35),
            onPressed: () {
              showAlertDialog(context);
            },
          ),
          Expanded(
            child: SizedBox(
              child: textFormField(
                controller: chatProvider.messageControl,
                type: TextInputType.multiline,
                validate: (value) {
                  return null;
                },
                hint: 'اكتب رسالة...',
                textAlignVertical: TextAlignVertical.center,
                isExpanded: true,
              ),
            ),
          ),
          if (chatProvider.isLoading) const SizedBox(width: 5),
          if (chatProvider.isLoading)
            Container(
              padding: const EdgeInsets.all(10),
              child: circularProgressIndicator(lightGrey, primaryColor),
            ),
          if (!chatProvider.isLoading)
            IconButton(
              color: lightGrey,
              icon: const Icon(Icons.send, size: 30),
              disabledColor: lightGrey,
              onPressed: () {
                chatProvider.messageControl.text.isEmpty
                    ? null
                    : chatProvider.sendMessage(
                        widget.chatId, chatProvider.messageControl.text.trim(), 'message');
              },
            ),
        ],
      ),
    );
  }
}
