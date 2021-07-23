  import 'dart:async';

  import 'package:articles/models/articles.dart';
  import 'package:articles/network/list_connect.dart';
  import 'package:articles/utils/article_subject_short_text_list_details.dart';
  import 'package:rxdart/rxdart.dart';

  class SearchBloc {
    MailSubjectShortTextListDetails _articleSubjectShortTextListDetails;
    List<Article> articleSearchList = List<Article>();
    ListConnect _listConnect = ListConnect();
    List<Article> searchList = List<Article>();
    int lastTimeStamp;

    SearchBloc({this.articleSearchList}) {
      articlesFoundStreamSink.add(articleSearchList);
      _articleSubjectShortTextListDetails =
          MailSubjectShortTextListDetails(articleSearchList: articleSearchList);
    }
    final BehaviorSubject<String> _articleSubjectShortTextBehaviorSubject =
        BehaviorSubject<String>();
    final StreamController<List<Article>> _articlesFoundStreamController =
        StreamController<List<Article>>();

    StreamSink<String> get articleSubjectShortTextStreamSink =>
        _articleSubjectShortTextBehaviorSubject.sink;
    StreamSink<List<Article>> get articlesFoundStreamSink =>
        _articlesFoundStreamController.sink;

    Stream<String> get articleSubjectShortTextStream =>
        _articleSubjectShortTextBehaviorSubject.stream;
    Stream<List<Article>> get articlesFoundStream =>
        _articlesFoundStreamController.stream;

    void searchBox(String query) async {
      searchList = List<Article>();
      Map<String, dynamic> mapBody = Map<String, dynamic>();
      mapBody['query'] = query;
      mapBody['filters'] = {};
      mapBody['page'] = 0;
      _listConnect
          .sendMailPost(mapBody, ListConnect.listSearchArticle)
          .then((Map<String, dynamic> mapResponse) {
        if (mapResponse['code'] == 200) {
          List<dynamic> dynamicList =
              mapResponse['content']['results'] as List<dynamic>;
          dynamicList
              .map((i) => searchList.add(Article.fromJSONInbox(i)))
              .toList();
          articlesFoundStreamSink.add(searchList);
        }
      });
    }

    void dispose() {
      _articleSubjectShortTextBehaviorSubject.close();
      _articlesFoundStreamController.close();
    }
  }
