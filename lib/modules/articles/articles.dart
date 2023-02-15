import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/articles/show%20article.dart';
import 'package:news/modules/matches%20statistics/statistics.dart';
import 'package:news/providers/articles%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class Articles extends StatefulWidget {
  const Articles({Key? key}) : super(key: key);

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  late ArticlesProvider articlesProvider;

  @override
  Widget build(BuildContext context) {
    articlesProvider = Provider.of(context);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateAndFinish(context, const Statistics());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (articles.isNotEmpty)
                  InkWell(
                    onTap: () {
                      navigateTo(context, ShowArticle(articles[0]));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: white,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        padding: const EdgeInsets.all(5),
                        width: sizeFromWidth(context, 1),
                        height: sizeFromHeight(context, 3.5),
                        decoration: BoxDecoration(
                          color: lightGrey,
                          borderRadius: BorderRadius.circular(0),
                          image: articles[0].poster != '' ?DecorationImage(
                            image: NetworkImage(articles[0].poster),
                            fit: BoxFit.fill,
                          ) : null,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: textWidget(
                          articles[0].title,
                          TextDirection.rtl,
                          null,
                          white,
                          sizeFromWidth(context, 25),
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ConditionalBuilder(
                  condition: articles.isNotEmpty,
                  builder: (context) {
                    return SizedBox(
                      height: sizeFromHeight(context, 5),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = articles;
                          if (index != 0) {
                            return InkWell(
                              onTap: () {
                                navigateTo(context, ShowArticle(data[index]));
                              },
                              child: Container(
                                width: sizeFromWidth(context, 3),
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: lightGrey,
                                  borderRadius: BorderRadius.circular(10),
                                  image: data[index].poster != ''
                                      ? DecorationImage(
                                          image:
                                              NetworkImage(data[index].poster),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                alignment: Alignment.bottomCenter,
                                child: textWidget(
                                    data[index].title,
                                    TextDirection.rtl,
                                    null,
                                    white,
                                    sizeFromWidth(context, 30),
                                    FontWeight.bold,
                                    null,
                                    1),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        itemCount: articles.length,
                      ),
                    );
                  },
                  fallback: (context) {
                    return const Center();
                  },
                ),
                if (otherArticles.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                        'آخر الأخبار',
                        null,
                        null,
                        primaryColor,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                    ],
                  ),
                if (otherArticles.isNotEmpty)
                  for (int i = 0; i < otherArticles.length; i++)
                    itemArticle(otherArticles[i].title, otherArticles[i].poster,
                        i, otherArticles[i]),
                if (!articlesProvider.isLoading && otherArticles.isNotEmpty)
                  itemArticle('', '', otherArticles.length),
                if (articlesProvider.isLoading && otherArticles.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                        child:
                            circularProgressIndicator(lightGrey, primaryColor, context)),
                  ),
                if (articles.isEmpty)
                  SizedBox(
                    height: sizeFromHeight(context, 2),
                    child: Center(
                        child:
                            circularProgressIndicator(lightGrey, primaryColor, context)),
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

  Widget itemArticle(title, poster, index, [model]) {
    if (index < otherArticles.length) {
      return InkWell(
        onTap: () {
          navigateTo(context, ShowArticle(model));
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: textWidget(title, TextDirection.rtl, null, white,
                    sizeFromWidth(context, 30), FontWeight.bold, null, 1),
              ),
              Container(
                width: sizeFromHeight(context, 9),
                height: sizeFromHeight(context, 12),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                  image: poster != ''
                      ? DecorationImage(
                          image: NetworkImage(poster),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (index == otherArticles.length) {
      return InkWell(
        onTap: () {
          articlesProvider.getOtherArticles(false);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            color: lightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: textWidget(
                    'عرض المزيد',
                    null,
                    TextAlign.center,
                    primaryColor,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                    null,
                    1),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
