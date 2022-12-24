import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/matches%20statistics/show%20player.dart';
import 'package:news/modules/matches%20statistics/statistics.dart';
import 'package:provider/provider.dart';

import '../../models/player.dart';
import '../../providers/articles provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';

class PlayersTransaction extends StatefulWidget {
  const PlayersTransaction({Key? key}) : super(key: key);

  @override
  State<PlayersTransaction> createState() => _PlayersTransactionState();
}

class _PlayersTransactionState extends State<PlayersTransaction> {
  late ArticlesProvider articlesProvider;

  @override
  void initState() {
    Provider.of<ArticlesProvider>(context, listen: false).getPlayers();
    Provider.of<ArticlesProvider>(context, listen: false).getOtherPlayers(true);
    super.initState();
  }

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
                  image: AssetImage('assets/images/icon.jpeg'),
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
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'Player',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'Nat.',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
                SizedBox(width: sizeFromWidth(context, 10)),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: textWidget(
                    'Club',
                    null,
                    null,
                    white,
                    sizeFromWidth(context, 30),
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (articlesProvider.players.isEmpty)
                  SizedBox(
                    height: sizeFromHeight(context, 2),
                    child: Center(
                        child:
                            circularProgressIndicator(lightGrey, primaryColor)),
                  ),
                if (articlesProvider.players.isNotEmpty)
                  for (int i = 0; i < articlesProvider.players.length; i++)
                    itemPlayer(i, articlesProvider.players[i]),
                if (articlesProvider.otherPlayers.isNotEmpty)
                  for (int i = 0; i < articlesProvider.otherPlayers.length; i++)
                    itemPlayer(i, articlesProvider.otherPlayers[i]),
                if (!articlesProvider.isLoading &&
                    articlesProvider.otherPlayers.isNotEmpty)
                  itemPlayer(articlesProvider.otherPlayers.length, articlesProvider.otherPlayers[0]),
                if (articlesProvider.isLoading &&
                    articlesProvider.otherPlayers.isNotEmpty)
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

  Widget itemPlayer(index, PlayerModel playerModel) {
    if (index < articlesProvider.otherPlayers.length) {
      return InkWell(
        onTap: () {
          navigateTo(context, ShowPlayer(playerModel));
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: sizeFromWidth(context, 8),
                height: sizeFromWidth(context, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.profile.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: sizeFromWidth(context, 4),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: textWidget(
                      playerModel.name.trim(),
                      null,
                      null,
                      white,
                      sizeFromWidth(context, 40),
                      FontWeight.bold,
                      null,
                      1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: textWidget(
                      playerModel.position.trim(),
                      null,
                      null,
                      white,
                      sizeFromWidth(context, 40),
                      FontWeight.bold,
                      null,
                      1,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: sizeFromWidth(context, 12),
                height: sizeFromWidth(context, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.birthPlaceLogo.toString()),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: sizeFromWidth(context, 10)),
              Container(
                width: sizeFromWidth(context, 12),
                height: sizeFromWidth(context, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(playerModel.currentCubLogo.toString()),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (index == articlesProvider.otherPlayers.length) {
      return InkWell(
        onTap: () {
          articlesProvider.getOtherPlayers(false);
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
