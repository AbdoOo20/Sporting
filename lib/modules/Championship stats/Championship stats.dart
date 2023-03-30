
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/ifmis%20provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../home/home.dart';

class ChampionshipStats extends StatefulWidget {
  const ChampionshipStats({Key? key}) : super(key: key);

  @override
  State<ChampionshipStats> createState() => _ChampionshipStatsState();
}

class _ChampionshipStatsState extends State<ChampionshipStats> {
  late IFMISProvider ifmisProvider;

  @override
  void initState() {
    Provider.of<IFMISProvider>(context, listen: false).getChampionshipStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ifmisProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(
            Icons.home,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: ifmisProvider.championshipStatsModel.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () async {
                    var url = Uri.parse(
                        ifmisProvider.championshipStatsModel[index].link);
                    await launchUrl(url, mode: LaunchMode.inAppWebView);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    width: sizeFromWidth(context, 1),
                    height: sizeFromHeight(context, 10, hasAppBar: true),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF7f0e14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            ifmisProvider.championshipStatsModel[index].title,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: sizeFromWidth(context, 30),
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: sizeFromWidth(context, 7),
                          height: sizeFromHeight(context, 12, hasAppBar: true),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(ifmisProvider
                                    .championshipStatsModel[index].image),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
