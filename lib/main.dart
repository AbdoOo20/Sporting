import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:news/network/cash_helper.dart';
import 'package:news/providers/articles%20provider.dart';
import 'package:news/providers/chat%20provider.dart';
import 'package:news/providers/competition%20provider.dart';
import 'package:news/providers/ifmis%20provider.dart';
import 'package:news/providers/matches%20statistics%20provider.dart';
import 'package:news/providers/other%20provider.dart';
import 'package:news/providers/sport%20services%20provider.dart';
import 'package:news/providers/store%20provider.dart';
import 'package:news/providers/user%20provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'modules/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider<CompetitionProvider>(
          create: (context) => CompetitionProvider(),
        ),
        ChangeNotifierProvider<StoreProvider>(
          create: (context) => StoreProvider(),
        ),
        ChangeNotifierProvider<MatchesStatisticsProvider>(
          create: (context) => MatchesStatisticsProvider(),
        ),
        ChangeNotifierProvider<ArticlesProvider>(
          create: (context) => ArticlesProvider(),
        ),
        ChangeNotifierProvider<IFMISProvider>(
          create: (context) => IFMISProvider(),
        ),
        ChangeNotifierProvider<OtherProvider>(
          create: (context) => OtherProvider(),
        ),
        ChangeNotifierProvider<SportServicesProvider>(
          create: (context) => SportServicesProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'الاتحاد الدولى',
        home: SplashScreen(),
      ),
    );
  }
}
