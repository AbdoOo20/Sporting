import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/Evacuation%20Responsibilaty/EvacuationResponsibilaty.dart';
import 'package:news/modules/IntellectualProperty/IntellectualProperty.dart';
import 'package:news/modules/home/home.dart';
import 'package:news/modules/membership/membership.dart';
import 'package:news/modules/policies/policies.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/cash_helper.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../Authentication/log in.dart';
import '../Authentication/sign up.dart';
import '../Vision, mission and goals/Vision, mission and goals.dart';
import '../members/members.dart';
import '../notifications/notifications.dart';
import '../profile/profile.dart';

class DrawerSide extends StatefulWidget {
  const DrawerSide({Key? key}) : super(key: key);

  @override
  State<DrawerSide> createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  late UserProvider userProvider;
  var url = Uri.parse('whatsapp://send?phone=${966561195038}');

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

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of(context);

    return SizedBox(
      height: sizeFromHeight(context, 1),
      width: sizeFromWidth(context, 1.7),
      child: Drawer(
        child: Container(
          color: primaryColor,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: white,
                      radius: sizeFromWidth(context, 10),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFd1ad17),
                        radius: sizeFromWidth(context, 11),
                        backgroundImage:
                            const AssetImage("assets/images/icon.jpeg"),
                      ),
                    ),
                    const Spacer(),
                    textWidget(
                      'IFMIS',
                      null,
                      null,
                      white,
                      sizeFromWidth(context, 20),
                      FontWeight.bold,
                    ),
                  ],
                ),
              ),
              buildListTile(
                context,
                'الملف الشخصى',
                Icons.person_outline,
                () {
                  String email = CacheHelper.getData(key: 'email') ?? '';
                  if (email == '') {
                    navigateAndFinish(context, const SignUP());
                  } else {
                    var currentUser = FirebaseAuth.instance.currentUser!.uid;
                    Provider.of<UserProvider>(context, listen: false)
                        .getUserData(currentUser);
                    navigateAndFinish(context, Profile(currentUser, 'home'));
                  }
                },
              ),
              buildListTile(
                context,
                'أعضاء الاتحاد',
                Icons.remember_me_outlined,
                () {
                  navigateAndFinish(context, const Members());
                },
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  trailing: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                    ),
                    child: Text(
                      userProvider.numberOfNotifications.toString(),
                      style: TextStyle(
                        color: white,
                        fontSize: sizeFromWidth(context, 25),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    'التنبيهات',
                    style: TextStyle(
                      color: white,
                      fontSize: sizeFromWidth(context, 25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    String email = CacheHelper.getData(key: 'email') ?? '';
                    if (email == '') {
                      showAlertDialog(context);
                    } else {
                      navigateAndFinish(context, const Notifications());
                    }
                  },
                ),
              ),
              buildListTile(
                context,
                'الرؤية والرسالة والأهداف',
                Icons.lightbulb_outlined,
                () {
                  navigateAndFinish(context, const VisionMissionAndGoals());
                },
              ),
              buildListTile(
                context,
                'شروط العضوية',
                Icons.rule_folder_outlined,
                () {
                  navigateAndFinish(context, const Membership());
                },
              ),
              buildListTile(
                context,
                'سياسة الخصوصية',
                Icons.privacy_tip_outlined,
                () {
                  navigateAndFinish(context, const Policies());
                },
              ),
              buildListTile(
                context,
                'الملكية الفكرية',
                Icons.person_search_outlined,
                () {
                  navigateAndFinish(context, const IntellectualProperty());
                },
              ),
              buildListTile(
                context,
                'إخلاء المسئولية',
                Icons.person_search_outlined,
                () {
                  navigateAndFinish(context, const EvacuationResponsibilaty());
                },
              ),
              buildListTile(
                context,
                'تواصل معنا',
                Icons.call,
                () async {
                  await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
                },
              ),
              buildListTile(
                context,
                'تسجيل الخروج',
                Icons.logout,
                () {
                  FirebaseAuth.instance.signOut();
                  CacheHelper.saveData(key: 'email', value: '');
                  navigateAndFinish(context, const Home());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
