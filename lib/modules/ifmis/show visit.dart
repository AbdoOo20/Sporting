// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/show%20image/show%20image.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/ifmis/visit model.dart';
import '../../providers/chat provider.dart';
import '../../providers/ifmis provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'ifmis.dart';

class ShowVisit extends StatefulWidget {
  VisitModel visitModel;

  ShowVisit(this.visitModel, {Key? key}) : super(key: key);

  @override
  State<ShowVisit> createState() => _ShowVisitState();
}

class _ShowVisitState extends State<ShowVisit> {
  late IFMISProvider ifmisProvider;

  late ChatProvider chatProvider;

  @override
  void initState() {
    Provider.of<IFMISProvider>(context, listen: false)
        .getVisitDetails(widget.visitModel.id.toString())
        .then((value) {
      Provider.of<ChatProvider>(context, listen: false).initializeYoutubePlayer(
          Provider.of<IFMISProvider>(context, listen: false)
              .visitDetailsModel!
              .video);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ifmisProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: ifmisProvider.visitDetailsModel!.video.contains('youtu') &&
              chatProvider.youtubePlayerController.value.isFullScreen
          ? null
          : AppBar(
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
              leading: IconButton(
                onPressed: () {
                  navigateAndFinish(context, const IFMIS());
                },
                icon: Icon(Icons.arrow_back, color: white),
              ),
            ),
      body: ConditionalBuilder(
        condition: ifmisProvider.isLoading == false &&
            ifmisProvider.visitDetailsModel!.images.isNotEmpty,
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (ifmisProvider.visitDetailsModel!.video
                        .contains('youtu'))
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: YoutubePlayer(
                          controller: chatProvider.youtubePlayerController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: primaryColor,
                          progressColors: ProgressBarColors(
                            playedColor: primaryColor,
                            handleColor: lightGrey,
                          ),
                        ),
                      ),
                    if (ifmisProvider.visitDetailsModel!.video
                        .contains('youtu'))
                      SizedBox(height: sizeFromHeight(context, 40)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: textWidget(
                        ifmisProvider.visitDetailsModel!.title,
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: textWidget(
                        ifmisProvider.visitDetailsModel!.description,
                        TextDirection.rtl,
                        null,
                        black,
                        sizeFromWidth(context, 25),
                        FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1 / 1,
                        physics: const NeverScrollableScrollPhysics(),
                        children:
                            ifmisProvider.visitDetailsModel!.images.map((e) {
                          return InkWell(
                            onTap: () {
                              navigateTo(context, ShowImage(e.image));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF151515),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(e.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              if (!chatProvider.youtubePlayerController.value.isFullScreen &&
                  ifmisProvider.visitDetailsModel!.video.contains('youtu'))
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
          );
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(lightGrey, primaryColor, context),
          );
        },
      ),
    );
  }
}
