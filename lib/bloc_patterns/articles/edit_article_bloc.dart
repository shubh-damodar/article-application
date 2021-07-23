import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:articles/models/articles.dart';
import 'package:articles/models/tagList.dart';
import 'package:articles/network/action_connect.dart';
import 'package:articles/network/file_connect.dart';
import 'package:articles/network/list_connect.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/utils/date_category.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/validators/register_validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class EditBloc with RegisterValidators {
  BuildContext buildContext;
  ListConnect _listConnect = ListConnect();
  DateCategory _dateCategory = DateCategory();
  ActionConnect _actionConnect = ActionConnect();
  NavigationActions _navigationActions;

  // List<Article> articlesList = List<Article>();
  List<Article> relatedArticleList = List<Article>();
  FileConnect _fileConnect = FileConnect();
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
      shortDescriptionArticle,
      image,
      htmlCode;

  bool fevarticleArticle,
      watchLaterArticle,
      subscribeArticle,
      hasLikedArticle,
      hasUnlikedArticle;

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

  final BehaviorSubject<String> _articleImageAccessUrlBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get articleImageAccessUrlStreamSink =>
      _articleImageAccessUrlBehaviorSubject.sink;

  Stream<String> get articleImageAccessUrlStream =>
      _articleImageAccessUrlBehaviorSubject.stream;

  StreamSink<String> get articleImageStreamSink =>
      _articleImageStreamController.sink;
  StreamController<String> _articleImageStreamController =
      StreamController<String>.broadcast();
  Stream<String> get articleImageStream => _articleImageStreamController.stream;

  StreamController<List<String>> _listArticleTagsStreamController =
      StreamController<List<String>>.broadcast();

  StreamSink<List<String>> get listArticleTagsStreamSink =>
      _listArticleTagsStreamController.sink;

  Stream<List<String>> get listArticleTagsStream =>
      _listArticleTagsStreamController.stream;

  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;

//-----------------------------Drop Down Lang--------------------->>
  final BehaviorSubject<String> _languageBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get languageStreamSink => _languageBehaviorSubject.sink;

  Stream<String> get languageStream =>
      _languageBehaviorSubject.stream.transform(languageStreamTransformer);
//----------------------------------End------------------------>>

  void takePicture(img) async {
    File fileImage = img;
    String filePath = fileImage.path, fileName, fileExtension;
    fileName = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    fileExtension = filePath.substring(filePath.lastIndexOf('.') + 1);
    Map<String, dynamic> mapResponseGetDownloadUrl,
        mapResponseConfirm,
        updateMapResponse;
    mapResponseGetDownloadUrl = await _fileConnect.sendFileGet(
        '${FileConnect.uploadFileGetDownloadUrl}?type=general&fileName=$fileName&fileType=image/$fileExtension');

    int statusCode = await _fileConnect.uploadFile(
        mapResponseGetDownloadUrl['content']['signedUrl'],
        'image/$fileExtension',
        filePath);

    mapResponseConfirm = await _fileConnect.sendFileGet(
        '${FileConnect.uploadConfirmUploadToken}${mapResponseGetDownloadUrl['content']['uploadToken']}');

    articleImageStreamSink.add(
        '${Connect.filesUrl}${mapResponseConfirm['content']['accessUrl']}');

    articleImageAccessUrlStreamSink
        .add(mapResponseConfirm['content']['accessUrl']);
  }

  Future getArticleDetails(String id) async {
    relatedArticleList = List<Article>();
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.articleGetDetails}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        titleStreamSink.add(mapResponse['content']['title']);
        idStreamSink.add(mapResponse['content']['id']);
        contentStreamSink.add(mapResponse['content']['content']);
        image = mapResponse['content']['thumbnail'];
        thumbnailStreamSink.add(image);
        articleImageAccessUrlStreamSink.add(image);
        shortDescriptionStreamSink
            .add(mapResponse['content']['shortDescription'].toString());
        languageStreamSink.add(mapResponse['content']['language']);

        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~${mapResponse['content']['language']}");
//-------------------Fot Tags only ------------------------------->
        final dynamicList = mapResponse['content'];
        ArticleTags tags = new ArticleTags.fromJson(dynamicList);
        listArticleTagsStreamSink.add(tags.tags);
//-----------------------End ----------------------------------->
      }
    });
  }

  Future<String> appendImage([String s]) async {
    File fileImage = await FilePicker.getFile(type: FileType.IMAGE);
    String filePath = fileImage.path, fileName, fileExtension;
    fileName = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    fileExtension = filePath.substring(filePath.lastIndexOf('.') + 1);
    Map<String, dynamic> mapResponseGetDownloadUrl, mapResponseConfirm;
    mapResponseGetDownloadUrl = await _fileConnect.sendFileGet(
        '${FileConnect.uploadFileGetDownloadUrl}?type=general&fileName=$fileName&fileType=image/$fileExtension');

    int statusCode = await _fileConnect.uploadFile(
        mapResponseGetDownloadUrl['content']['signedUrl'],
        'image/$fileExtension',
        filePath);

    mapResponseConfirm = await _fileConnect.sendFileGet(
        '${FileConnect.uploadConfirmUploadToken}${mapResponseGetDownloadUrl['content']['uploadToken']}');

    String accessUrl = '';
    if (mapResponseConfirm['code'] == 200) {
      accessUrl =
          '${Connect.filesUrl}${mapResponseConfirm['content']['accessUrl']}';
    }
    return accessUrl;
  }

  void sendEditedArticale(
    String title,
    String shortDescription,
    String country,
    String language,
    String html,
    String tags,
    String id,
  ) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['id'] = "$id";
    mapBody['country'] = country;
    mapBody['title'] = title;
    mapBody['shortDescription'] = shortDescription;
    mapBody['language'] = _languageBehaviorSubject.value;
    mapBody['content'] = "$html";
    mapBody['tags'] = [tags];
    mapBody['isPublished'] = true;
    mapBody['thumbnail'] = "${_articleImageAccessUrlBehaviorSubject.value}";
    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailPost(mapBody, ListConnect.updateArticle);
    composeFinishedStreamSink.add(mapResponse);
  }

  Future deletMyArticle(String id) async {
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.deletMyArticle}$id');
    composeFinishedStreamSink.add(mapResponse);
    print('-------------------------------------$mapResponse');
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
      if (mapResponse['code'] == 200) {}
    });
  }

  void articleAssessSubscription(String id, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['articleId'] = id;
    mapBody['type'] = action;

    _listConnect
        .sendMailPost(mapBody, ListConnect.articleAssessSubscription)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  void commentArticle(String id, String comment) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['comment'] = comment;
    mapBody['parentId'] = id;

    _actionConnect
        .sendActionPost(mapBody, ActionConnect.commentArticleAdd)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
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
    _articleImageAccessUrlBehaviorSubject.close();
    _articleImageStreamController.close();
    _listArticleTagsStreamController.close();
    _composeFinishedStreamController.close();
    _languageBehaviorSubject.close();
  }
}
