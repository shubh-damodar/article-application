import 'dart:async';
import 'dart:io';
import 'package:articles/network/action_connect.dart';
import 'package:articles/network/file_connect.dart';
import 'package:articles/network/list_connect.dart';
import 'package:articles/network/user_connect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';

class ComposeBloc {
  Function modifyJSFunction;
  BuildContext buildContext;
  String conversationId, type, title = '', htmlCode, draftId, previousAction;
  Connect _connect = Connect();

  int indexattachment;
  FileConnect _fileConnect = FileConnect();
  ActionConnect _actionConnect = ActionConnect();
  ListConnect _listConnect = ListConnect();

  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;
  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  StreamSink<String> get articleImageStreamSink =>
      _articleImageStreamController.sink;
  StreamController<String> _articleImageStreamController =
      StreamController<String>.broadcast();
  Stream<String> get articleImageStream => _articleImageStreamController.stream;

  final BehaviorSubject<String> _articleImageAccessUrlBehaviorSubject =
      BehaviorSubject<String>();
  StreamSink<String> get articleImageAccessUrlStreamSink =>
      _articleImageAccessUrlBehaviorSubject.sink;
  Stream<String> get articleImageAccessUrlStream =>
      _articleImageAccessUrlBehaviorSubject.stream;

  void takePicture(img) async {
    File fileImage = await img;
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

  Future sendBodyMessage(
    String title,
    String shortDescription,
    String country,
    String conversationId,
    String html,
    String tags,
  ) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['country'] = country;
    mapBody['title'] = title;
    mapBody['shortDescription'] = shortDescription;
    mapBody['language'] = conversationId;
    mapBody['content'] = html;
    mapBody['tags'] = [tags];
    mapBody['isPublished'] = true;
    mapBody['thumbnail'] = _articleImageAccessUrlBehaviorSubject.value;
    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailPost(mapBody, ListConnect.addArticle);
    composeFinishedStreamSink.add(mapResponse);
  }

  Future<String> appendImage() async {
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

  void dispose() {
    _composeFinishedStreamController.close();
    _articleImageStreamController.close();
    _articleImageAccessUrlBehaviorSubject.close();
  }
}
