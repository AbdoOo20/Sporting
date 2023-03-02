
import 'package:flutter/material.dart';
import 'package:news/models/statistics/articles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/statistics/player.dart';
import '../shared/const.dart';

class ArticlesProvider with ChangeNotifier {
  int articleNumber = 2;
  int gameNumber = 2;
  int playerNumber = 2;
  bool isLoading = false;

  Future<void> getArticles() async {
    articles = [];
    String url = "https://api.iffsma-2030.com/Article/1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          articles.add(ArticlesModel.fromJSON(element));
          notifyListeners();
        });
      } catch (e) {}
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getOtherArticles(bool setArticle) async {
    if (setArticle) {
      otherArticles = [];
    }
    if (!setArticle) {
      isLoading = true;
      articleNumber++;
      notifyListeners();
    }
    String url = "https://api.iffsma-2030.com/Article/$articleNumber";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          otherArticles.add(ArticlesModel.fromJSON(element));
          notifyListeners();
        });
      } catch (e) {}
      isLoading = false;
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getPlayers() async {
    players = [];
    String url = "https://api.iffsma-2030.com/Players/1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          players.add(PlayerModel.fromJSON(element[0]));
          notifyListeners();
        });
      } catch (e) {}
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getOtherPlayers(bool setGame) async {
    if (setGame) {
      otherPlayers = [];
    }
    if (!setGame) {
      isLoading = true;
      playerNumber++;
      notifyListeners();
    }
    String url = "https://api.iffsma-2030.com/Players/$playerNumber";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          otherPlayers.add(PlayerModel.fromJSON(element[0]));
          notifyListeners();
        });
      } catch (e) {}
      isLoading = false;
    } else {
      throw Exception("Failed  to Load Post");
    }
  }
}
