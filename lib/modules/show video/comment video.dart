// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/other%20provider.dart';
import 'package:news/shared/Components.dart';
import 'package:provider/provider.dart';

import '../../shared/Style.dart';
import '../../shared/const.dart';

class CommentVideo extends StatefulWidget {
  String title;

  CommentVideo(this.title, {Key? key}) : super(key: key);

  @override
  State<CommentVideo> createState() => _CommentVideoState();
}

class _CommentVideoState extends State<CommentVideo> {
  late OtherProvider otherProvider;
  TextEditingController videoComment = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    otherProvider = Provider.of(context);
    return Scaffold(
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
                  image: AssetImage('assets/images/logo 2.jpeg'),
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
      ),
      body: Form(
        key: key,
        child: Column(
          children: [
            textFormField(
              controller: videoComment,
              type: TextInputType.text,
              validate: (value) {
                if (value!.isEmpty) {
                  return 'يجب كتابة تعليق';
                }
                return null;
              },
              hint: 'كتابة تعليق',
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (key.currentState!.validate()) {
                        otherProvider
                            .sendVideoComment(
                                widget.title, videoComment.text.trim())
                            .then((value) {
                          videoComment.clear();
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: textWidget(
                        'إرسال تعليق',
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              color: primaryColor,
              height: sizeFromHeight(context, 10),
              width: sizeFromWidth(context, 1),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: CarouselSlider(
                  items: downBanners.map((e) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(e.image),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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
    );
  }
}
