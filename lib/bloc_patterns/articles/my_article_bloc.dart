import 'dart:async';

import 'package:articles/models/articles.dart';
import 'package:articles/network/action_connect.dart';
import 'package:articles/network/list_connect.dart';


class MyArticleBloc {
  ListConnect _listConnect = ListConnect();
  ActionConnect _actionConnect = ActionConnect();
  List<Article> articlesList = List<Article>();
  int lastTimeStamp;
  StreamController<List<Article>> _articlesStreamController =
      StreamController<List<Article>>.broadcast();

  StreamSink<List<Article>> get articlesStreamSink => _articlesStreamController.sink;

  Stream<List<Article>> get articlesStream => _articlesStreamController.stream;

  void getReceivedMessages() async {
    articlesList = List<Article>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['query'] = "";
    mapBody['filters'] = {};
    mapBody['lastItemId'] = "";
    _listConnect
        .sendMailPost(mapBody, ListConnect.myArticle)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content'] as List<dynamic>;
        dynamicList
            .map((i) => articlesList.add(Article.fromJSONSentBox(i)))
            .toList();
        articlesStreamSink.add(articlesList);
        if (articlesList.isNotEmpty) {
        }
      }
    });
  }

  void dispose() {
    _articlesStreamController.close();
  }
}
