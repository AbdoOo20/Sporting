// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:news/modules/play_store/play%20store.dart';
import 'package:news/providers/store%20provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/const.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ShowStore extends StatefulWidget {
  String storeId;
  String link;

  ShowStore(this.storeId, this.link, {Key? key}) : super(key: key);

  @override
  State<ShowStore> createState() => _ShowStoreState();
}

class _ShowStoreState extends State<ShowStore> {
  late StoreProvider storeProvider;

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false)
        .getImages(widget.storeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
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
          onPressed: () {
            navigateAndFinish(context, const PlayStore());
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: sizeFromWidth(context, 1),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(storeProvider.links[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              itemCount: storeProvider.links.length,
            ),
          ),
          Container(
            width: sizeFromWidth(context, 1),
            height: sizeFromHeight(context, 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: textButton(
                    context,
                    'open store',
                    primaryColor,
                    white,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                    () async {
                      var url = Uri.parse(widget.link);
                      await launchUrl(url, mode: LaunchMode.inAppWebView);
                    },
                  ),
                )
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
