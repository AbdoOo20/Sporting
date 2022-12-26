// ignore_for_file: use_build_context_synchronously, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/providers/other%20provider.dart';
import 'package:news/shared/Components.dart';
import 'package:news/shared/Style.dart';
import 'package:provider/provider.dart';

import '../../providers/articles provider.dart';
import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Provider.of<ArticlesProvider>(context, listen: false).getPlayers();
    Provider.of<ArticlesProvider>(context, listen: false).getOtherPlayers(true);
    Provider.of<ArticlesProvider>(context, listen: false).getArticles();
    Provider.of<ArticlesProvider>(context, listen: false).getOtherArticles(true);
    Provider.of<OtherProvider>(context, listen: false).getBanners();
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
