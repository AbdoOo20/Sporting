import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:news/modules/competitions/Fans_vote.dart';
import 'package:news/providers/competition%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../home/home.dart';
import 'package:jiffy/jiffy.dart';

class Competitions extends StatefulWidget {
  const Competitions({Key? key}) : super(key: key);

  @override
  State<Competitions> createState() => _CompetitionsState();
}

class _CompetitionsState extends State<Competitions> {
  String getState(String startTime, String endTime) {
    startTime = Jiffy(startTime).yMMMd.toString();
    endTime = Jiffy(endTime).yMMMd.toString();
    if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return 'لم تبدأ';
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0)) {
      return 'انتهت';
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays ==
            0)) {
      return 'جارى التنفيذ';
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays <
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return 'جارى التنفيذ';
    } else if ((intl.DateFormat.yMMMd()
                .parse(startTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays ==
            0) &&
        (intl.DateFormat.yMMMd()
                .parse(endTime)
                .difference(intl.DateFormat.yMMMd()
                    .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
                .inDays >
            0)) {
      return 'جارى التنفيذ';
    }
    return '';
  }

  String getDate(String endTime) {
    endTime = Jiffy(endTime).yMMMd.toString();
    if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays >
        0)) {
      return 'سيتم إغلاق التصويت بتاريخ: ' '$endTime';
    } else if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays <
        0)) {
      return 'تم إغلاق التصويت بتاريخ: ' '$endTime';
    } else if ((intl.DateFormat.yMMMd()
            .parse(endTime)
            .difference(intl.DateFormat.yMMMd()
                .parse(intl.DateFormat.yMMMd().format(DateTime.now())))
            .inDays ==
        0)) {
      return 'سيتم إغلاق التصويت اليوم';
    }
    return '';
  }

  late CompetitionProvider competitionProvider;

  @override
  void initState() {
    Provider.of<CompetitionProvider>(context, listen: false).getCompetitions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    competitionProvider = Provider.of(context);
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
              itemCount: competitionProvider.competitions.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    navigateAndFinish(
                      context,
                      FansVote(
                        competitionProvider.competitions[index],
                        getDate(
                            competitionProvider.competitions[index].endDate),
                        getState(
                                    competitionProvider
                                        .competitions[index].startDate,
                                    competitionProvider
                                        .competitions[index].endDate) ==
                                'انتهت'
                            ? true
                            : false,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    width: sizeFromWidth(context, 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF7f0e14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          getState(
                              competitionProvider.competitions[index].startDate,
                              competitionProvider.competitions[index].endDate),
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 30),
                            fontWeight: FontWeight.bold,
                            color: getState(
                                        competitionProvider
                                            .competitions[index].startDate,
                                        competitionProvider
                                            .competitions[index].endDate) ==
                                    'انتهت'
                                ? Colors.blue
                                : getState(
                                            competitionProvider
                                                .competitions[index].startDate,
                                            competitionProvider
                                                .competitions[index].endDate) ==
                                        'لم تبدأ'
                                    ? Colors.amber
                                    : Colors.green,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${competitionProvider.competitions[index].name}\nعدد المتسابقين: ${competitionProvider.competitions[index].subscribers}',
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
                                image: NetworkImage(competitionProvider
                                    .competitions[index].image),
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
