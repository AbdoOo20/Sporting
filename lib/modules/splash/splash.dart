// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:news/shared/Components.dart';
import 'package:news/shared/Style.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';


import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> setIP() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    Provider.of<UserProvider>(context, listen: false).setIpAddress(allInfo['id']);
  }

  @override
  void initState() {
    setIP();
    Timer(
      const Duration(seconds: 4),
      () {
        navigateAndFinish(context, const Home());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeFromWidth(context, 1),
      height: sizeFromHeight(context, 1),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
