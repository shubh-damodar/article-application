import 'dart:async';
import 'package:articles/models/articles.dart';
import 'package:articles/network/action_connect.dart';
import 'package:articles/network/list_connect.dart';

class ReadLaterBloc {
  ListConnect _listConnect = ListConnect();
  ActionConnect _actionConnect = ActionConnect();
  List<Article> mailsList = List<Article>();
  int lastTimeStamp;
  StreamController<List<Article>> _readLaterListStreamController =
      StreamController<List<Article>>.broadcast();

  StreamSink<List<Article>> get readLaterListStreamSink =>
      _readLaterListStreamController.sink;

  Stream<List<Article>> get readLaterListStream =>
      _readLaterListStreamController.stream;

  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;

  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  void readLaterArticleList() async {
    mailsList = List<Article>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    _listConnect
        .sendMailPost(mapBody, ListConnect.readLaterArticle)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['articles'] as List<dynamic>;
        dynamicList
            .map((i) => mailsList.add(Article.fromJSONDraftList(i)))
            .toList();
        readLaterListStreamSink.add(mailsList);
      }
    });
  }

  void timeMarkWatch(String id) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['articleId'] = id;
    mapBody['action'] = "remove";
    _listConnect
        .sendMailPost(mapBody, ListConnect.readLaterAction)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        composeFinishedStreamSink.add(mapResponse);
      }
    });
  }

  void markUnmarkFavorite(String id, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['articleId'] = id;
    mapBody['action'] = action;
    _listConnect
        .sendMailPost(mapBody, ListConnect.acctionAdd)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  void trashAllArticle() async {
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders(ListConnect.readLaterClearAll);
    if (mapResponse['code'] == 200) {}
  }

  void dispose() {
    _readLaterListStreamController.close();
    _composeFinishedStreamController.close();
  }
}
