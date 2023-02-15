import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/ifmis%20provider.dart';
import 'package:provider/provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';
import '../../shared/const.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  late IFMISProvider ifmisProvider;

  @override
  void initState() {
    Provider.of<IFMISProvider>(context, listen: false).getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ifmisProvider = Provider.of(context);
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
            navigateAndFinish(context, const Home());
          },
          icon: Icon(Icons.home, color: white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: ifmisProvider.memberModel.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () async {
                    ifmisProvider
                        .getMemberDetails(
                            ifmisProvider.memberModel[index].id.toString())
                        .then((value) {
                      showModalBottomSheet(
                        context: context,
                        elevation: 0.001,
                        backgroundColor: primaryColor,
                        constraints: BoxConstraints(
                          maxWidth: sizeFromWidth(context, 1),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: sizeFromWidth(context, 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: sizeFromWidth(context, 3),
                                  height: sizeFromWidth(context, 3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(ifmisProvider
                                          .memberDetailsModel.image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: textWidget(
                                    ifmisProvider.memberDetailsModel.name,
                                    null,
                                    null,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: sizeFromWidth(context, 10)),
                                  child: textWidget(
                                    ifmisProvider.memberDetailsModel.job,
                                    null,
                                    TextAlign.center,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 5),
                                  child: textWidget(
                                    ifmisProvider.memberDetailsModel.countryName,
                                    null,
                                    null,
                                    white,
                                    sizeFromWidth(context, 25),
                                    FontWeight.w400,
                                  ),
                                ),
                                Container(
                                  width: sizeFromWidth(context, 8),
                                  height: sizeFromWidth(context, 12),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(ifmisProvider
                                          .memberDetailsModel.countryImage),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(5),
                    width: sizeFromWidth(context, 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF7f0e14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            ifmisProvider.memberModel[index].name,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: sizeFromWidth(context, 20),
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                        SizedBox(width: sizeFromWidth(context, 10)),
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
      ),
    );
  }
}
