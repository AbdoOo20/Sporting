// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/sport%20services/show%20news%20spore%20details.dart';
import 'package:news/modules/sport%20services/sport%20services.dart';
import 'package:provider/provider.dart';

import '../../network/cash_helper.dart';
import '../../providers/sport services provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import 'add news sport.dart';

class ShowsNewsSport extends StatefulWidget {
  String id;

  ShowsNewsSport(this.id, {Key? key}) : super(key: key);

  @override
  State<ShowsNewsSport> createState() => _ShowsNewsSportState();
}

class _ShowsNewsSportState extends State<ShowsNewsSport> {
  late SportServicesProvider servicesProvider;

  @override
  void initState() {
    Provider.of<SportServicesProvider>(context, listen: false)
        .getSportServicesNews(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    servicesProvider = Provider.of(context);
    var id = CacheHelper.getData(key: 'id');
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
            navigateAndFinish(context, const SportServices());
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                navigateTo(context, AddNewsSport(widget.id));
              },
              icon: Icon(Icons.add_circle, color: white)),
        ],
      ),
      body: ConditionalBuilder(
        condition: !servicesProvider.isLoading,
        builder: (context) {
          return Column(
            children: [
              Container(
                width: sizeFromWidth(context, 1),
                height: sizeFromHeight(context, 11, hasAppBar: true),
                color: primaryColor,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: textFormField(
                    controller: servicesProvider.search,
                    type: TextInputType.text,
                    validate: (value) {
                      return null;
                    },
                    onChange: (value) {
                      if (servicesProvider.search.text == '') {
                        servicesProvider.getSportServicesNews(widget.id);
                      }
                      servicesProvider.searchAboutNews();
                    },
                    hint: 'ابحث هنا',
                    isExpanded: true,
                    textAlignVertical: TextAlignVertical.bottom,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: servicesProvider.sportServicesNewsModel.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        navigateTo(
                            context,
                            ShowNewsSporeDetails(servicesProvider
                                .sportServicesNewsModel[index]));
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
                            if (id ==
                                servicesProvider
                                    .sportServicesNewsModel[index].user.id)
                              IconButton(
                                  onPressed: () {
                                    servicesProvider.deleteNews(servicesProvider
                                        .sportServicesNewsModel[index].id.toString()).then((value){
                                      servicesProvider.getSportServicesNews(widget.id);
                                    });
                                  },
                                  icon: Icon(Icons.delete, color: white)),
                            const Spacer(),
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: textWidget(
                                  servicesProvider
                                      .sportServicesNewsModel[index].title,
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
                                  image: NetworkImage(
                                    servicesProvider
                                        .sportServicesNewsModel[index]
                                        .images[0]
                                        .image,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
