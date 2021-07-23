import 'dart:async';

import 'package:articles/models/articles.dart';
import 'package:articles/network/action_connect.dart';
import 'package:articles/network/list_connect.dart';

class FevBloc {
  ListConnect _listConnect = ListConnect();
  ActionConnect _actionConnect = ActionConnect();
  List<Article> articlesList = List<Article>();
  int lastTimeStamp;
  StreamController<List<Article>> _articlesStreamController =
      StreamController<List<Article>>.broadcast();

  StreamSink<List<Article>> get articlesStreamSink =>
      _articlesStreamController.sink;

  Stream<List<Article>> get articlesStream => _articlesStreamController.stream;

  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;

  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  void getReceivedMessages() async {
    articlesList = List<Article>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    _listConnect
        .sendMailPost(mapBody, ListConnect.favouriteArticle)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['articles'] as List<dynamic>;
        dynamicList
            .map((i) => articlesList.add(Article.fromJSONStarred(i)))
            .toList();
        articlesStreamSink.add(articlesList);
      }
    });
  }

  void markUnmarkFavorite(String id) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['articleId'] = id;
    mapBody['action'] = "remove";
    _listConnect
        .sendMailPost(mapBody, ListConnect.acctionAdd)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        composeFinishedStreamSink.add(mapResponse);
      }
    });
  }

  void timeMarkWatch(String id, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['articleId'] = id;
    mapBody['action'] = action;

    _listConnect
        .sendMailPost(mapBody, ListConnect.readLaterAction)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  void trashAllArticle() async {
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders(ListConnect.fevouriteClearAll);
    if (mapResponse['code'] == 200) {}
  }

  void dispose() {
    _articlesStreamController.close();
    _composeFinishedStreamController.close();
  }
}
