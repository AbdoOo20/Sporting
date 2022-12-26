// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/models/statistics/articles.dart';
import 'package:news/modules/articles/articles.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class ShowArticle extends StatefulWidget {
  ArticlesModel articlesModel;
  ShowArticle(this.articlesModel, {Key? key}) : super(key: key);

  @override
  State<ShowArticle> createState() => _ShowArticleState();
}

class _ShowArticleState extends State<ShowArticle> {
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
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  width: sizeFromWidth(context, 1),
                  height: sizeFromHeight(context, 3.5),
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image:
                      NetworkImage(widget.articlesModel.poster),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: textWidget(
                    widget.articlesModel.title.trim(),
                    TextDirection.rtl,
                    null,
                    white,
                    sizeFromWidth(context, 25),
                    FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: textWidget(
                    widget.articlesModel.content.trim(),
                    TextDirection.rtl,
                    null,
                    primaryColor,
                    sizeFromWidth(context, 25),
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
    );
  }
}
