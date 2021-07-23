import 'dart:async';
import 'package:articles/models/articles.dart';
import 'package:articles/network/action_connect.dart';
import 'package:articles/network/list_connect.dart';
import '../../models/articles.dart';

class ExploreArticleBloc {
  ListConnect _listConnect = ListConnect();
  ActionConnect _actionConnect = ActionConnect();
  List<Article> articleList = List<Article>();

  int lastTimeStamp;
  StreamController<List<Article>> _articlesStreamController =
      StreamController<List<Article>>.broadcast();

  StreamSink<List<Article>> get articlesStreamSink =>
      _articlesStreamController.sink;

  Stream<List<Article>> get articlesStream => _articlesStreamController.stream;

  void getReceivedArticle() async {
    articleList = List<Article>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['query'] = "";
    mapBody['filters'] = {};
    mapBody['page'] = 0;
    _listConnect
        .sendMailPost(mapBody, ListConnect.listSearchArticle)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList
            .map((i) => articleList.add(Article.fromJSONInbox(i)))
            .toList();
        articlesStreamSink.add(articleList);
      }
    });
  }

  void getFurtherMessages(i) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['query'] = "";
    mapBody['filters'] = {};
    mapBody['page'] = '$i';
    List<Article> newMessagesList = List<Article>();
    _listConnect
        .sendMailPost(mapBody, ListConnect.listSearchArticle)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList
            .map((i) => newMessagesList.add(Article.fromJSONInbox(i)))
            .toList();
        articleList.addAll(newMessagesList);
        articlesStreamSink.add(articleList);
      }
    });
  }

  void watchLeter(i) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['query'] = "";
    mapBody['filters'] = {};
    mapBody['page'] = '$i';
    List<Article> newMessagesList = List<Article>();
    _listConnect
        .sendMailPost(mapBody, ListConnect.listSearchArticle)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        print("In the furtur text");
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList
            .map((i) => newMessagesList.add(Article.fromJSONInbox(i)))
            .toList();
        articleList.addAll(newMessagesList);
        articlesStreamSink.add(articleList);
      }
    });
  }

  void dispose() {
    _articlesStreamController.close();
  }
}
