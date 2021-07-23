import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:articles/network/user_connect.dart';

import '../main.dart';

class ListConnect {
//  String _listBaseUrl = 'http://mail.simplifying.world/apis/v1.0.1/list/';

  String _listBaseUrl = 'https://www.mesbro.com/apis/v1.0.1/';

  static String listSearchArticle = 'article/search',
      myArticle = 'article/list',
      readLaterArticle = 'article/read-later/list',
      favouriteArticle = 'article/favourite/list',
      relatedArticle = 'article/related-articles',
      articleGetDetails = 'article/getdetails?id=',
      addArticle = 'article/add',
      commentArticle = 'comments/add',
      reportArticleAdd = 'report/user-items',
      acctionAdd = 'article/favourite/action',
      readLaterAction = "article/read-later/action",
      articleassesslike = "article/assess-like",
      articleAssessSubscription = 'article/assess-subscription',
      fevouriteClearAll = "article/favourite/clear?query=",
      readLaterClearAll = "article/read-later/clear?query=",
      updateArticle = 'article/update',
      deletMyArticle = 'article/delete?id=',
      a = '';


  Future<Map<String, dynamic>> sendMailPost(
      Map<String, dynamic> mapBody, String url) async {
    http.Response response = await http
        .post('$_listBaseUrl$url', body: json.encode(mapBody), headers: {
      'au': Connect.currentUser == null ? '' : Connect.currentUser.au,
      'ut-${Connect.currentUser.au}': '${Connect.currentUser.token}',
      "Content-Type": "application/json"
    });
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendMailPostWithHeaders(
      dynamic mapBody, String url) async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse('$_listBaseUrl$url'));
    request.headers.add('au', Connect.currentUser.au);
    request.headers
        .add('ut-${Connect.currentUser.au}', '${Connect.currentUser.token}');
    request.add(utf8.encode(json.encode(mapBody)));
    HttpClientResponse httpClientResponse = await request.close();
    String response = await httpClientResponse.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(response);
    return map;
  }

  Future<Map<String, dynamic>> sendMailGet(String url) async {
    http.Response response = await http.get('$_listBaseUrl$url');
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendMailGetWithHeaders(String url) async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse('$_listBaseUrl$url'));
    request.headers.add('au', Connect.currentUser.au);
    request.headers
        .add('ut-${Connect.currentUser.au}', '${Connect.currentUser.token}');
    HttpClientResponse httpClientResponse = await request.close();
    String response = await httpClientResponse.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(response);
    return map;
  }
}
