import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:news/modules/Authentication/log%20in.dart';
import 'package:news/modules/Authentication/sign%20up.dart';
import 'package:news/modules/Championship%20stats/Championship%20stats.dart';
import 'package:news/modules/ifmis/ifmis.dart';
import 'package:news/modules/matches%20statistics/statistics.dart';
import 'package:news/modules/policies/policies.dart';
import 'package:news/modules/profile/profile.dart';
import 'package:news/network/cash_helper.dart';
import 'package:news/shared/Components.dart';
import 'package:news/shared/const.dart';
import 'package:provider/provider.dart';
import '../../providers/user provider.dart';
import '../../shared/Style.dart';
import '../Chat/category chat.dart';
import '../competitions/Competitions.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserProvider userProvider;
  bool? showPolicies = CacheHelper.getData(key: 'showPolicies');

  showAlertDialog(BuildContext context) {
    Widget cancelButton = textButton(
      context,
      'تسجيل الدخول',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        navigateAndFinish(context, const LogIn());
      },
    );
    Widget continueButton = textButton(
      context,
      'إنشاء حساب',
      primaryColor,
      white,
      sizeFromWidth(context, 20),
      FontWeight.bold,
      () {
        navigateAndFinish(context, const SignUP());
      },
    );
    AlertDialog alert = AlertDialog(
      title: textWidget(
        'يجب إنشاء حساب أو تسجيل الدخول',
        null,
        TextAlign.end,
        black,
        sizeFromWidth(context, 25),
        FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: continueButton),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: cancelButton),
            ],
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showContainerPolicies(BuildContext context) {
    return Container(
      width: sizeFromWidth(context, 1),
      height: sizeFromHeight(context, 5.5),
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: sizeFromWidth(context, 20)),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            'هل أنت موافق على شروط سياسة الخصوصية ؟',
            null,
            null,
            primaryColor,
            sizeFromWidth(context, 25),
            FontWeight.bold,
          ),
          textWidget(
            'يمكنك الإطلاع على شروط الإستخدام والموافقة عليها',
            null,
            null,
            primaryColor,
            sizeFromWidth(context, 30),
            FontWeight.bold,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: textButton(
                  context,
                  'نعم',
                  primaryColor,
                  white,
                  sizeFromWidth(context, 20),
                  FontWeight.bold,
                  () {
                    CacheHelper.saveData(key: 'showPolicies', value: true);
                    setState(() {
                      showPolicies = true;
                    });
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: textButton(
                  context,
                  'عرض',
                  primaryColor,
                  white,
                  sizeFromWidth(context, 20),
                  FontWeight.bold,
                  () {
                    navigateAndFinish(context, const Policies());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // String email = CacheHelper.getData(key: 'email') ?? '';
    // if (email != '') {
    //   Provider.of<UserProvider>(context, listen: false)
    //       .getNumberOfNotifications();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerSide(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: white),
          backgroundColor: primaryColor,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(sizeFromWidth(context, 20)),
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFFbdbdbd),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo 2.jpeg'),
                  ),
                ),
              ),
              Text(
                'IFMIS ',
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
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                String token = CacheHelper.getData(key: 'token') ?? '';
                if (token == '') {
                  navigateAndFinish(context, const SignUP());
                } else {
                  Provider.of<UserProvider>(context, listen: false)
                      .getDataUser(context, token);
                  navigateAndFinish(context, Profile(token, 'home', false, false, ''));
                }
              },
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Container(
                  height: sizeFromHeight(context, 20, hasAppBar: false),
                  width: sizeFromWidth(context, 1),
                  color: white,
                  child: Card(
                    elevation: 10,
                    color: white,
                    child: Marquee(
                      text:
                          "للحصول على اخر نسخه من تطبيق الاتحاد الدولي - IFMIS .  نرجوا تحديث التطبيق من موقع السوق Google play و Apple store",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: black),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 50,
                      accelerationDuration: const Duration(microseconds: 30),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeFromHeight(context, 10),
                  width: sizeFromWidth(context, 1),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: CarouselSlider(
                      items: upBanners.map((element) {
                        return Container(
                          height: sizeFromHeight(context, 10),
                          width: sizeFromWidth(context, 1),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(element.image),
                              fit: BoxFit.fill,
                            ),
                          ),
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
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/2.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                'دردشة الجماهير الرياضية',
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                              String token =
                                  CacheHelper.getData(key: 'token') ?? '';
                              if (token == '') {
                                showAlertDialog(context);
                              } else {
                                navigateAndFinish(
                                    context, const CategoryChat());
                              }
                            },
                          ),
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/5.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                'الأخبار و الرياضة',
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                              navigateAndFinish(context, const Statistics());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/3.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                'الدورات الرياضية',
                                null,
                                null,
                                black,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {},
                          ),
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/4.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                'التصويت والمسابقات الرياضية',
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                              String token =
                                  CacheHelper.getData(key: 'token') ?? '';
                              if (token == '') {
                                showAlertDialog(context);
                              } else {
                                navigateAndFinish(
                                    context, const Competitions());
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/11.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                'المتجر الرياضى',
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                             // navigateAndFinish(context, const PlayStore());
                            },
                          ),
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/10.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                'الألعاب والترفيه',
                                null,
                                null,
                                black,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                              showToast(
                                  text: 'جارى العمل عليها',
                                  state: ToastStates.SUCCESS);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/6.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                '',
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                              showToast(
                                  text: 'جارى العمل عليها',
                                  state: ToastStates.SUCCESS);
                            },
                          ),
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/8.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                'أعمال الإتحاد الدولى',
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                              navigateAndFinish(context, const IFMIS());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/9.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                '',
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                              showToast(
                                  text: 'جارى العمل عليها',
                                  state: ToastStates.SUCCESS);
                            },
                          ),
                          materialWidget(
                            context,
                            sizeFromWidth(context, 2),
                            sizeFromWidth(context, 2.2),
                            10,
                            const AssetImage('assets/images/7.png'),
                            BoxFit.cover,
                            [
                              textWidget(
                                'أخبار الإتحادات الدولية',
                                null,
                                null,
                                white,
                                sizeFromWidth(context, 30),
                                FontWeight.w500,
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            scaffoldColor,
                            () {
                              navigateAndFinish(
                                  context, const ChampionshipStats());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
            if (showPolicies == null) showContainerPolicies(context),
          ],
        ),
      ),
    );
  }
}
