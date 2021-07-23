import 'dart:collection';

import 'package:articles/bloc_patterns/profile_bloc.dart';
import 'package:articles/models/articles.dart';
import 'package:articles/screens/article/compose_article_page.dart';
import 'package:articles/screens/article/my_article_edit.dart';
import 'package:articles/screens/article/View_Article/view_article_page.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:articles/bloc_patterns/articles/my_article_bloc.dart';
import 'package:articles/models/user.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/utils/date_category.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/network_connectivity.dart';
import 'package:articles/utils/shared_pref_manager.dart';
import 'package:articles/utils/widgets_collection.dart';
import 'package:shimmer/shimmer.dart';

class MyArticlesPage extends StatefulWidget {
  final String userId;
  MyArticlesPage({this.userId});
  _MyArticlesPageState createState() => _MyArticlesPageState();
}

class _MyArticlesPageState extends State<MyArticlesPage> {
  final MyArticleBloc _myArticleBloc = MyArticleBloc();
  DateCategory _dateCategory = DateCategory();
  double _screenWidth, _screenHeight;
  DateTime currentBackPressDateTime;
  String userId;
  List<User> _usersList = List<User>();
  final ProfileBloc _profileBloc = ProfileBloc();
  LinkedHashMap<String, String> _settingsRouteLinkedHashMap =
      LinkedHashMap<String, String>();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  final ScrollController _scrollController = ScrollController();
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _myArticleBloc.getReceivedMessages();
    _profileBloc.getAllUserDetails(widget.userId);

    if (widget.userId == Connect.currentUser.userId) {
    } else {}
    userId = widget.userId;
    super.initState();
  }

  void dispose() {
    super.dispose();
    _profileBloc.dispose();
    _myArticleBloc.dispose();
    _scrollController.dispose();
  }

  Future<void> _getAllUsers() async {
    await SharedPrefManager.getAllUsers().then((List<User> user) {
      setState(() {
        _usersList = user;
      });
    });
  }

  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _navigationActions.navigateToScreenWidget(ComposeArticlePage());
            },
            backgroundColor: Colors.deepOrange,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.deepOrange),
            centerTitle: true,
            title: Text('My Articles',
                style: TextStyle(color: Colors.deepOrange, fontSize: 16.0)),
            backgroundColor: Colors.white,
          ),
          body: Container(
            margin: EdgeInsets.only(top: 1.0),
            child: StreamBuilder(
                stream: _myArticleBloc.articlesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Article>> asyncSnapshot) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: asyncSnapshot.data == null
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16.0),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  child: Column(
                                    children: [0, 1, 2, 3]
                                        .map((_) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: _screenWidth,
                                                    height: 150.0,
                                                    color: Colors.white,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              )
                            : asyncSnapshot.data.length == 0
                                ? Container(
                                    child: Center(
                                    child: Text('No Article Yet....'),
                                  ))
                                : ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: asyncSnapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Stack(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: Card(
                                                elevation: 5,
                                                child: Column(
                                                  children: [
                                                    Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 200.0,
                                                          child: Hero(
                                                            tag:   "TagList${asyncSnapshot.data[index].thumbnail}",
                                                            child:
                                                                CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              width:
                                                                  _screenWidth,
                                                              imageUrl:
                                                                  "${Connect.filesUrl}${asyncSnapshot.data[index].thumbnail}",
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 8.0),
                                                                  child: Text(
                                                                    '${asyncSnapshot.data[index].title}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            51,
                                                                            51,
                                                                            51)),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 4.0),
                                                                  child: Text(
                                                                    '${asyncSnapshot.data[index].shortDescription}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13.0,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          112,
                                                                          122,
                                                                          112),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 6.0,
                                                                      bottom:
                                                                          7.0),
                                                                  child: Text(
                                                                    '${asyncSnapshot.data[index].addedBy}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            51,
                                                                            51,
                                                                            51)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                _navigationActions
                                                    .navigateToScreenWidget(
                                                        ViewArticle(
                                                  userId: Connect
                                                      .currentUser.userId,
                                                  id: asyncSnapshot
                                                      .data[index].id,
                                                ));
                                              },
                                            ),
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: Card(
                                                margin: EdgeInsets.all(5),
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: 17,
                                                          color: Colors.white,
                                                        ),
                                                        onTap: () {
                                                          _navigationActions
                                                              .navigateToScreenWidget(
                                                                  EditArticlePage(
                                                            userId:
                                                                asyncSnapshot
                                                                    .data[index]
                                                                    .id,
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                      ),
                    ],
                  );
                }),
          )),
    );
  }
}
