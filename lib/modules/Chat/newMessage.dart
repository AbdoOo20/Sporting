// ignore_for_file: must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:news/providers/chat%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';

class NewMessages extends StatefulWidget {
  String id;
  String chatId;

  NewMessages(this.id, this.chatId, {Key? key}) : super(key: key);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  late ChatProvider chatProvider;
  dynamic user = FirebaseAuth.instance.currentUser;

  showAlertDialog(BuildContext context) {
    Widget cancelButton = textButton(
      context,
      'اختر صورة',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        chatProvider.pickImage(widget.id, widget.chatId);
        navigatePop(context);
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
        chatProvider.pickVideo(widget.id, widget.chatId);
        navigatePop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        'اختر من المعرض',
        null,
        TextAlign.end,
        black,
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
                onChange: (value) {
                  chatProvider.setMessage(value.toString().trim());
                },
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
          if ((!chatProvider.isLoading && chatProvider.enteredMessage != '') ||
              (!chatProvider.isLoading && chatProvider.pickedImage != null))
            IconButton(
              color: lightGrey,
              icon: const Icon(Icons.send, size: 30),
              disabledColor: lightGrey,
              onPressed: () {
                chatProvider.enteredMessage == '' &&
                        chatProvider.pickedImage == null
                    ? null
                    : chatProvider.sendMessage(
                        context, widget.id, widget.chatId);
              },
            ),
          if (!chatProvider.isLoading &&
              chatProvider.enteredMessage == '' &&
              chatProvider.pickedImage == null)
            IconButton(
              icon: Icon(
                chatProvider.isRecord ? Icons.stop : Icons.mic,
                size: 30,
                color: lightGrey,
              ),
              onPressed: () {
                if (chatProvider.isRecord) {
                  chatProvider.isRecord = false;
                  chatProvider.toggleRecording(
                      user!.uid, widget.id, widget.chatId);
                } else if (!chatProvider.isRecord) {
                  chatProvider.isRecord = true;
                  chatProvider.toggleRecording(
                      user!.uid, widget.id, widget.chatId);
                }
              },
            ),
        ],
      ),
    );
  }
}
