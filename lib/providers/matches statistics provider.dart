import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:news/shared/Style.dart';
import '../models/statistics/matches scores.dart';
import '../models/statistics/matches statistics.dart';
import '../models/statistics/team.dart';

class MatchesStatisticsProvider with ChangeNotifier {
  List<MatchesStatisticsModel> matches = [];
  List<MatchesScoresModel> scores = [];
  List<TeamModel> teams = [];
  String date = '';
  String getNameOfDay = '';

  Future<void> getMatches(String date) async {
    matches = [];
    String url = "https://api.iffsma-2030.com/TMA/index.php?data=$date&timezone=+03";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          matches.add(MatchesStatisticsModel.fromJSON(element));
        });
      } catch (e) {
        log(e.toString());
      }
      notifyListeners();
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  void getDateOfDay() {
    date = '';
    getNameOfDay = '';
    date = DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(DateTime.now().toString()));
    getNameOfDay = '';
  }

  void getNameDay(String day) {
    switch (day) {
      case 'Monday':
        getNameOfDay = 'الاثنين';
        break;
      case 'Tuesday':
        getNameOfDay = 'الثلاثاء';
        break;
      case 'Wednesday':
        getNameOfDay = 'الأربعاء';
        break;
      case 'Thursday':
        getNameOfDay = 'الخميس';
        break;
      case 'Friday':
        getNameOfDay = 'الجمعة';
        break;
      case 'Saturday':
        getNameOfDay = 'السبت';
        break;
      case 'Sunday':
        getNameOfDay = 'الأحد';
        break;
      default:
        getNameOfDay = '';
        break;
    }
    notifyListeners();
  }

  Future<void> selectDatePerDay(BuildContext context) async {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2, 3, 5),
      maxTime: DateTime(3500, 6, 7),
      onChanged: (dateNow) {
        date = DateFormat("dd/MM/yyyy").format(dateNow);
        getNameDay(DateFormat('EEEE').format(dateNow));
        date = date.replaceAll('/', '-');
        matches = [];
        notifyListeners();
        getMatches(date);
      },
      onConfirm: (dateNow) {
        date = DateFormat("dd/MM/yyyy").format(dateNow);
        getNameDay(DateFormat('EEEE').format(dateNow));
        date = date.replaceAll('/', '-');
        matches = [];
        notifyListeners();
        getMatches(date);
      },
      currentTime: DateTime.now(),
      theme: DatePickerTheme(
        cancelStyle: TextStyle(color: primaryColor),
        doneStyle: TextStyle(color: primaryColor),
      ),
    );
  }

  Future<void> getScores(String champion) async {
    scores = [];
    String url = "https://api.iffsma-2030.com/jdwel/$champion-scorers";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          scores.add(MatchesScoresModel.fromJSON(element));
        });
      } catch (e) {
        log(e.toString());
      }
      notifyListeners();
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getTeams(String champion) async {
    teams = [];
    String url = "https://api.iffsma-2030.com/jdwel/$champion";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          teams.add(TeamModel.fromJSON(element));
        });
      } catch (e) {
        log(e.toString());
      }
      notifyListeners();
    } else {
      throw Exception("Failed  to Load Post");
    }
  }
}
