import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/models/games.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/articles provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class Funny extends StatefulWidget {
  const Funny({Key? key}) : super(key: key);

  @override
  State<Funny> createState() => _FunnyState();
}

class _FunnyState extends State<Funny> {
  late ArticlesProvider articlesProvider;

  @override
  void initState() {
    Provider.of<ArticlesProvider>(context, listen: false).getGames();
    Provider.of<ArticlesProvider>(context, listen: false).getOtherGames(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    articlesProvider = Provider.of(context);
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
              height: sizeFromHeight(context, 15, hasAppBar: true),
              width: sizeFromWidth(context, 5),
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
          icon: const Icon(Icons.home),
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (articlesProvider.games.isEmpty)
                  SizedBox(
                    height: sizeFromHeight(context, 2),
                    child: Center(
                        child:
                        circularProgressIndicator(lightGrey, primaryColor)),
                  ),
                if (articlesProvider.games.isNotEmpty)
                  for (int i = 0; i < articlesProvider.games.length; i++)
                    itemGame(
                        articlesProvider.games[i].title,
                        articlesProvider.games[i].image,
                        i,
                        articlesProvider.games[i]),
                if (articlesProvider.otherGames.isNotEmpty)
                  for (int i = 0; i < articlesProvider.otherGames.length; i++)
                    itemGame(
                        articlesProvider.otherGames[i].title,
                        articlesProvider.otherGames[i].image,
                        i,
                        articlesProvider.otherGames[i], false),
                if (!articlesProvider.isLoading &&
                    articlesProvider.otherGames.isNotEmpty)
                  itemGame('', '', articlesProvider.otherGames.length, articlesProvider.otherGames[0],false),
                if (articlesProvider.isLoading &&
                    articlesProvider.otherGames.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                        child:
                            circularProgressIndicator(lightGrey, primaryColor)),
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
  Widget itemGame(title, image, index, GameModel model,[bool isGames = true]) {
    if (index < articlesProvider.games.length && isGames && model.title != '') {
      return InkWell(
        onTap: () async{
          var url = Uri.parse(model.url);
          await launchUrl(url, mode: LaunchMode.inAppWebView);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: textWidget(
                    title.trim(),
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  )),
              Container(
                width: sizeFromWidth(context, 8),
                height: sizeFromWidth(context, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(image),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (index < articlesProvider.otherGames.length && !isGames && model.title != '') {
      return InkWell(
        onTap: () async{
          var url = Uri.parse(model.url);
          await launchUrl(url, mode: LaunchMode.inAppWebView);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: textWidget(
                    title.trim(),
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  )),
              Container(
                width: sizeFromWidth(context, 8),
                height: sizeFromWidth(context, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(image),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (index == articlesProvider.otherGames.length && !isGames) {
      return InkWell(
        onTap: () {
          articlesProvider.getOtherGames(false);
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
