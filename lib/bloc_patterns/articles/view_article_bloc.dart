import 'dart:async';
import 'dart:core';

import 'package:articles/models/articles.dart';
import 'package:articles/network/action_connect.dart';
import 'package:articles/network/list_connect.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/utils/date_category.dart';
import 'package:flutter/material.dart';

class ViewArticleBloc {
  BuildContext buildContext;
  Connect _userConnect = Connect();
  ListConnect _listConnect = ListConnect();
  DateCategory _dateCategory = DateCategory();
  ActionConnect _actionConnect = ActionConnect();
  List<Article> articlesList = List<Article>();
  List<Article> relatedArticleList = List<Article>();
  List<Article> commentList = List<Article>();

  int lastTimeStamp,
      subscribersArticle,
      addedAtArticle,
      likesArticle,
      dislikesArticle;
  String titleArticle,
      idArticle,
      contentArticle,
      thumbnailArticle,
      ownerArticle,
      shortDescriptionArticle;

  bool fevarticleArticle,
      watchLaterArticle,
      subscribeArticle,
      hasLikedArticle,
      hasUnlikedArticle;
  int addedAt;

  // int likesArticle = null;

  StreamController<String> _articlesStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get articlesStreamSink => _articlesStreamController.sink;

  Stream<String> get articlesStream => _articlesStreamController.stream;

  StreamController<String> _idStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get idStreamSink => _idStreamController.sink;

  Stream<String> get idStream => _idStreamController.stream;

  StreamController<String> _titleStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get titleStreamSink => _titleStreamController.sink;

  Stream<String> get titleStream => _titleStreamController.stream;

  StreamController<String> _contentStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get contentStreamSink => _contentStreamController.sink;

  Stream<String> get contentStream => _contentStreamController.stream;

  StreamController<String> _likesStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get likesStreamSink => _likesStreamController.sink;

  Stream<String> get likesStream => _likesStreamController.stream;

  StreamController<String> _dislikesStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get dislikesStreamSink => _dislikesStreamController.sink;

  Stream<String> get dislikesStream => _dislikesStreamController.stream;

  StreamController<String> _addedAtStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get addedAtStreamSink => _addedAtStreamController.sink;

  Stream<String> get addedAtStream => _addedAtStreamController.stream;

  StreamController<String> _subscribersStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get subscribersStreamSink =>
      _subscribersStreamController.sink;

  Stream<String> get subscribersStream => _subscribersStreamController.stream;

  StreamController<String> _thumbnailStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get thumbnailStreamSink => _thumbnailStreamController.sink;

  Stream<String> get thumbnailStream => _thumbnailStreamController.stream;

  StreamController<String> _shortDescriptionStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get shortDescriptionStreamSink =>
      _shortDescriptionStreamController.sink;

  Stream<String> get shortDescriptionStream =>
      _shortDescriptionStreamController.stream;

  StreamController<List<Article>> _listArticleStreamController =
      StreamController<List<Article>>.broadcast();

  StreamSink<List<Article>> get listArticleStreamSink =>
      _listArticleStreamController.sink;

  Stream<List<Article>> get listArticleStream =>
      _listArticleStreamController.stream;

  StreamController<String> _ownerStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get ownerStreamSink => _ownerStreamController.sink;

  Stream<String> get ownerStream => _ownerStreamController.stream;

  StreamController<bool> _fevarticleStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get fevarticleStreamSink => _fevarticleStreamController.sink;

  Stream<bool> get fevarticleStream => _fevarticleStreamController.stream;

  StreamController<bool> _watchLaterStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get watchLaterStreamSink => _watchLaterStreamController.sink;

  Stream<bool> get watchLaterStream => _watchLaterStreamController.stream;

  StreamController<bool> _hasLikedStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get hasLikedStreamSink => _hasLikedStreamController.sink;

  Stream<bool> get hasLikedStream => _hasLikedStreamController.stream;

  StreamController<bool> _hasUnlikedStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get hasUnlikedStreamSink => _hasUnlikedStreamController.sink;

  Stream<bool> get hasUnlikedStream => _hasUnlikedStreamController.stream;

  StreamController<bool> _subscribeStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get subscribeStreamSink => _subscribeStreamController.sink;

  Stream<bool> get subscribeStream => _subscribeStreamController.stream;

  //--------------------User Details------------------------->
  // StreamController<String> _nameOwnerStreamController =
  //     StreamController<String>.broadcast();

  // StreamSink<String> get nameOwnerStreamSink => _nameOwnerStreamController.sink;

  // Stream<String> get nameOwnerStream => _nameOwnerStreamController.stream;

  // StreamController<String> _genderOwnerStreamController =
  //     StreamController<String>.broadcast();

  // StreamSink<String> get genderOwnerStreamSink =>
  //     _genderOwnerStreamController.sink;

  // Stream<String> get genderOwnerStream => _genderOwnerStreamController.stream;

  // StreamController<String> _birthOwnerStreamController =
  //     StreamController<String>.broadcast();

  // StreamSink<String> get birthOwnerStreamSink =>
  //     _birthOwnerStreamController.sink;

  // Stream<String> get birthOwnerStream => _birthOwnerStreamController.stream;

  // StreamController<String> _emailOwnerStreamController =
  //     StreamController<String>.broadcast();

  // StreamSink<String> get emailOwnerStreamSink =>
  //     _emailOwnerStreamController.sink;

  // Stream<String> get emailOwnerStream => _emailOwnerStreamController.stream;

  // StreamController<String> _joiningOwnerStreamController =
  //     StreamController<String>.broadcast();

  // StreamSink<String> get joiningOwnerStreamSink =>
  //     _joiningOwnerStreamController.sink;

  // Stream<String> get joiningOwnerStream => _joiningOwnerStreamController.stream;

  // StreamController<String> _modifyDateOwnerStreamController =
  //     StreamController<String>.broadcast();

  // StreamSink<String> get modifyDateOwnerStreamSink =>
  //     _modifyDateOwnerStreamController.sink;

  // Stream<String> get modifyDateOwnerStream =>
  //     _modifyDateOwnerStreamController.stream;

  //------------------------End---------------------------->

  // --------------------TabProfile----------------------->

  final StreamController<Map<String, dynamic>> _tabProfileStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSink<Map<String, dynamic>> get tabProfileStreamSink =>
      _tabProfileStreamController.sink;
  Stream<Map<String, dynamic>> get tabProfileStream =>
      _tabProfileStreamController.stream;
  // ---------------------End------------------------------->

  //--------------------Commenr List------------------------->
  StreamController<List<Article>> commentsListStreamController =
      StreamController<List<Article>>.broadcast();
  StreamSink<List<Article>> get commentsListStreamSink =>
      commentsListStreamController.sink;
  Stream<List<Article>> get commentsListStream =>
      commentsListStreamController.stream;
  //-----------------------End----------------------------->

  //--------------------Commenr List------------------------->
  StreamController<List<Article>> commentsListNatedStreamController =
      StreamController<List<Article>>.broadcast();
  StreamSink<List<Article>> get commentsListNatedStreamSink =>
      commentsListNatedStreamController.sink;
  Stream<List<Article>> get commentsListNatedStream =>
      commentsListNatedStreamController.stream;
  //-----------------------End----------------------------->

  //---------------------Compose Refresh-------------------->
  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;
  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;
  //------------------------End----------------------------->

  Future getAllUserDetails(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.articleGetDetails}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        titleStreamSink.add(mapResponse['content']['title']);

        idStreamSink.add(mapResponse['content']['id']);

        contentStreamSink.add(mapResponse['content']['content']);

        addedAtStreamSink.add(_dateCategory.ddMMyyyyDateFormat.format(
            DateTime.fromMillisecondsSinceEpoch(
                mapResponse['content']["addedAt"])));

        Future.delayed(Duration.zero, () {
          subscribersStreamSink
              .add(mapResponse['content']["subscribers"].toString());
        });

        thumbnailStreamSink.add(mapResponse['content']["thumbnail"]);

        shortDescriptionStreamSink
            .add(mapResponse['content']['shortDescription'].toString());

//------------------------Profile Details ------------------------------>
        // String personProfile = mapResponse['content']['owner'];
        // _userConnect
        //     .sendGet('${Connect.userPersonalProfileUsername}$personProfile')
        //     .then((Map<String, dynamic> mapResponse) {
        //   if (mapResponse['code'] == 200) {
        //     // print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$mapResponse");`a
        //     Map<String, dynamic> userMap = mapResponse['content'];
        //     tabProfileStreamSink.add(userMap);
        //   }
        // });
//------------------------End ------------------------------>

        likesStreamSink.add(mapResponse['content']['likes'].toString());

        dislikesStreamSink.add(mapResponse['content']['unlikes'].toString());

        fevarticleStreamSink.add(mapResponse['content']['favouriteStatus']);

        watchLaterStreamSink.add(mapResponse['content']['watchLater']);

        hasLikedStreamSink.add(mapResponse['content']['hasLiked']);

        hasUnlikedStreamSink.add(mapResponse['content']['hasUnliked']);

        subscribeStreamSink.add(mapResponse['content']['hasSubscribed']);
      }
    });
  }

  Future getAuthorDetails(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.articleGetDetails}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        String personProfile = mapResponse['content']['owner'];
        _userConnect
            .sendGet('${Connect.userPersonalProfileUsername}$personProfile')
            .then((Map<String, dynamic> mapResponse) {
          if (mapResponse['code'] == 200) {
            Map<String, dynamic> userMap = mapResponse['content'];
            tabProfileStreamSink.add(userMap);
          }
        });
      }
    });
  }

  void getAllRealtedArticle(String id) async {
    relatedArticleList = List<Article>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['articleId'] = id;
    mapBody['page'] = 0;
    _listConnect
        .sendMailPost(mapBody, ListConnect.relatedArticle)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList
            .map((i) =>
                relatedArticleList.add(Article.fromJSONRelatedArticle(i)))
            .toList();
        listArticleStreamSink.add(relatedArticleList);
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

  void likeArticle(String id, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['articleId'] = id;
    mapBody['type'] = action;

    _listConnect
        .sendMailPost(mapBody, ListConnect.articleassesslike)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        dislikesStreamSink.add(mapResponse['content']['unlikes'].toString());
        likesStreamSink.add(mapResponse['content']['likes'].toString());
        hasLikedStreamSink.add(mapResponse['content']['hasLiked']);
        hasUnlikedStreamSink.add(mapResponse['content']['hasUnliked']);
      }
    });
  }

  void articleAssessSubscription(String id, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['articleId'] = id;
    mapBody['type'] = action;

    _listConnect
        .sendMailPost(mapBody, ListConnect.articleAssessSubscription)
        .then((Map<String, dynamic> mapResponse) async {
      if (mapResponse['code'] == 200) {
        subscribersStreamSink
            .add('${mapResponse['content']['subscribersCount']}');
      }
    });
  }

  void commentArticle(String id, String comment) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['comment'] = comment;
    mapBody['parentId'] = id;
    _actionConnect
        .sendActionPost(mapBody, ActionConnect.commentArticleAdd)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        composeFinishedStreamSink.add(mapResponse);
      }
    });
  }

  void reportArticle(String id, String comment) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['description'] = comment;
    mapBody['id'] = id;
    mapBody['type'] = 'article';
    _listConnect
        .sendMailPost(mapBody, ListConnect.reportArticleAdd)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  Future getCommentList(String id) async {
    commentList = List<Article>();
    await _actionConnect
        .sendActionGetWithHeaders('${ActionConnect.commentList}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;
        dynamicList
            .map((i) => commentList.add(Article.fromJSONCommentList(i)))
            .toList();
        commentsListStreamSink.add(commentList);
      }
    });
  }

  Future getCommentListNasted(String id) async {
    commentList = List<Article>();
    await _actionConnect
        .sendActionGetWithHeaders('${ActionConnect.commentList}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;
        dynamicList
            .map((i) => commentList.add(Article.fromJSONCommentList(i)))
            .toList();
        // commentsListStreamSink.add(commentList);
        print("---------------------------$mapResponse");
      }
    });
  }

  void commentLike(String commentId, String parentId, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['commentId'] = "$commentId";
    mapBody['parentId'] = "$parentId";
    mapBody['type'] = '$action';
    _actionConnect
        .sendActionPost(mapBody, ActionConnect.commentLike)
        .then((Map<String, dynamic> mapResponse) {
      commentsListStreamSink.add(commentList);
      if (mapResponse['code'] == 200) {}
    });
  }

  void commentReply(String commentId, String parentId, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['commentId'] = "$commentId";
    mapBody['parentId'] = "$parentId";
    mapBody['reply'] = '$action';
    _actionConnect
        .sendActionPost(mapBody, ActionConnect.commentsReply)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  void dispose() {
    _articlesStreamController.close();
    _idStreamController.close();
    _titleStreamController.close();
    _contentStreamController.close();
    _likesStreamController.close();
    _addedAtStreamController.close();
    _subscribersStreamController.close();
    _thumbnailStreamController.close();
    _shortDescriptionStreamController.close();
    _fevarticleStreamController.close();
    _listArticleStreamController.close();
    _ownerStreamController.close();
    _watchLaterStreamController.close();
    _dislikesStreamController.close();
    _hasLikedStreamController.close();
    _hasUnlikedStreamController.close();
    _subscribeStreamController.close();
    _tabProfileStreamController.close();
    commentsListStreamController.close();
    commentsListNatedStreamController.close();
    _composeFinishedStreamController.close();
  }
}
