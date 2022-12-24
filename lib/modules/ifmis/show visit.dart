// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/show%20image/show%20image.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../providers/chat provider.dart';
import '../../providers/ifmis provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../show video/show video.dart';
import 'ifmis.dart';

class ShowVisit extends StatefulWidget {
  String title;
  String content;
  String id;
  String video;

  ShowVisit(this.title, this.content, this.id, this.video, {Key? key})
      : super(key: key);

  @override
  State<ShowVisit> createState() => _ShowVisitState();
}

class _ShowVisitState extends State<ShowVisit> {
  late IFMISProvider ifmisProvider;

  late ChatProvider chatProvider;

  @override
  void initState() {
    Provider.of<IFMISProvider>(context, listen: false).getImages(widget.id);
    Provider.of<ChatProvider>(context, listen: false)
        .initializeYoutubePlayer(widget.video);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ifmisProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: white,
      appBar: widget.video.contains('youtu') &&
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
                        image: AssetImage('assets/images/icon.jpeg'),
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (widget.video.contains('youtu'))
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
                if (widget.video.contains('youtu'))
                  SizedBox(height: sizeFromHeight(context, 40)),
                if (!widget.video.contains('youtu'))
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.play_circle_fill_rounded,
                              color: white),
                          onPressed: () {
                            navigateTo(context, ShowVideo(widget.video));
                          },
                        ),
                        textWidget(
                          widget.title,
                          TextDirection.rtl,
                          null,
                          white,
                          sizeFromWidth(context, 25),
                          FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: textWidget(
                    widget.content,
                    TextDirection.rtl,
                    null,
                    black,
                    sizeFromWidth(context, 25),
                    FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          navigateTo(
                              context, ShowImage(ifmisProvider.links[index]));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF151515),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(ifmisProvider.links[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: ifmisProvider.links.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1 / 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!chatProvider.youtubePlayerController.value.isFullScreen &&
              widget.video.contains('youtu'))
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
}
