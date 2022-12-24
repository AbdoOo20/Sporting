import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news/models/articles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/models/games.dart';
import 'package:news/models/player.dart';

class ArticlesProvider with ChangeNotifier {
  List<ArticlesModel> articles = [];
  List<ArticlesModel> otherArticles = [];
  List<GameModel> games = [];
  List<GameModel> otherGames = [];
  List<PlayerModel> players = [];
  List<PlayerModel> otherPlayers = [];
  int articleNumber = 2;
  int gameNumber = 2;
  int playerNumber = 2;
  bool isLoading = false;

  Future<void> getArticles() async {
    articles = [];
    String url = "https://api.ifmis-2030.icu/Article/1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          articles.add(ArticlesModel.fromJSON(element));
          notifyListeners();
        });
      } catch (e) {
        log(e.toString());
      }
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
    String url = "https://api.ifmis-2030.icu/Article/$articleNumber";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          otherArticles.add(ArticlesModel.fromJSON(element));
          notifyListeners();
        });
      } catch (e) {
        log(e.toString());
      }
      isLoading = false;
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getGames() async {
    games = [];
    String url = "https://api.ifmis-2030.icu/Games/1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data.forEach((element) {
        games.add(GameModel.fromJSON(element));
        notifyListeners();
      });
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getOtherGames(bool setGame) async {
    if (setGame) {
      otherGames = [];
    }
    if (!setGame) {
      isLoading = true;
      gameNumber++;
      notifyListeners();
    }
    String url = "https://api.ifmis-2030.icu/Games/$gameNumber";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data.forEach((element) {
        notifyListeners();
        otherGames.add(GameModel.fromJSON(element));
        notifyListeners();
      });
      isLoading = false;
    } else {
      throw Exception("Failed  to Load Post");
    }
  }

  Future<void> getPlayers() async {
    players = [];
    String url = "https://api.ifmis-2030.icu/Players/1";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          players.add(PlayerModel.fromJSON(element[0]));
          notifyListeners();
        });
      } catch (e) {
        log(e.toString());
      }
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
    String url = "https://api.ifmis-2030.icu/Players/$playerNumber";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        data.forEach((element) {
          otherPlayers.add(PlayerModel.fromJSON(element[0]));
          notifyListeners();
        });
      } catch (e) {
        log(e.toString());
      }
      isLoading = false;
    } else {
      throw Exception("Failed  to Load Post");
    }
  }
}
