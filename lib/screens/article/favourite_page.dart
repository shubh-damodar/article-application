import 'package:articles/models/articles.dart';
import 'package:articles/screens/article/explore_page.dart';
import 'package:articles/screens/article/View_Article/view_article_page.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:articles/bloc_patterns/articles/favourite_bloc.dart';
import 'package:articles/models/user.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/utils/date_category.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/network_connectivity.dart';
import 'package:articles/utils/shared_pref_manager.dart';
import 'package:articles/utils/widgets_collection.dart';
import 'package:shimmer/shimmer.dart';

class FavouriteArticlePage extends StatefulWidget {
  _FavouriteArticlePageState createState() => _FavouriteArticlePageState();
}

class _FavouriteArticlePageState extends State<FavouriteArticlePage> {
  final FevBloc _fevListBloc = FevBloc();
  DateCategory _dateCategory = DateCategory();
  double _screenWidth, _screenHeight;
  DateTime currentBackPressDateTime;
  List<User> _usersList = List<User>();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  final ScrollController _scrollController = ScrollController();

  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _fevListBloc.getReceivedMessages();
  }

  void dispose() {
    super.dispose();
    _fevListBloc.dispose();
    _scrollController.dispose();
  }

  Future<void> _getAllUsers() async {
    await SharedPrefManager.getAllUsers().then((List<User> user) {
      setState(() {
        _usersList = user;
      });
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Favourite Article"),
          content: Text("Do yo want to remove all Favourite Articles?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                _fevListBloc.trashAllArticle();
                _widgetsCollection
                    .showToastMessage("All Favourite Articles Removed");
                setState(() {
                  _navigationActions
                      .navigateToScreenWidget(ExploreArticlePage());
                });
              },
            )
          ],
        );
      },
    );
  }

  Future<bool> _removeArticel(String id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to Remove From Aricle'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  _fevListBloc.markUnmarkFavorite(id);
                  Navigator.of(context).pop(false);
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Favourite Articles',
            style: TextStyle(color: Colors.deepOrange, fontSize: 16.0),
          ),
          actions: <Widget>[
            StreamBuilder(
                stream: _fevListBloc.articlesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Article>> asyncSnapshot) {
                  return asyncSnapshot.data == null
                      ? Container(
                          width: 0,
                          height: 0,
                        )
                      : asyncSnapshot.data.length == 0
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {
                                _showDialog();
                              },
                            );
                }),
          ],
        ),
        body: Container(
            margin: EdgeInsets.only(top: 1.0),
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: _fevListBloc.composeFinishedStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
                    return asyncSnapshot.data == null
                        ? Container(width: 0.0, height: 0.0)
                        : asyncSnapshot.data.length == 0
                            ? Container(width: 0.0, height: 0.0)
                            : _composeFinished(asyncSnapshot.data);
                  },
                ),
                StreamBuilder(
                    stream: _fevListBloc.articlesStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Article>> asyncSnapshot) {
                      return Expanded(
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
                                    child: Text('No Article yet...'),
                                  ))
                                : ListView.builder(
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: asyncSnapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _navigationActions
                                              .navigateToScreenWidget(
                                                  ViewArticle(
                                            userId: Connect.currentUser.userId,
                                            id: asyncSnapshot.data[index].id,
                                            previousScreen: 'explore_page',
                                          ));
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Card(
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
                                                            width: _screenWidth,
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
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            8.0),
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
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            4.0,
                                                                        bottom:
                                                                            10),
                                                                child: Text(
                                                                  '${asyncSnapshot.data[index].shortDescription}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            112,
                                                                            122,
                                                                            112),
                                                                  ),
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
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: Card(
                                                margin: EdgeInsets.all(5),
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                child: Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Icon(
                                                            Icons.watch_later,
                                                            color: Colors.white,
                                                            size: 17,
                                                          )),
                                                      onTap: () {
                                                        _fevListBloc
                                                            .timeMarkWatch(
                                                                asyncSnapshot
                                                                    .data[index]
                                                                    .id,
                                                                'add');
                                                        _widgetsCollection
                                                            .showToastMessage(
                                                                "Added to Wwatch Later");
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Icon(
                                                              Icons.star,
                                                              size: 17,
                                                              color: Colors
                                                                  .deepOrange)),
                                                      onTap: () {
                                                        _removeArticel(
                                                            asyncSnapshot
                                                                .data[index]
                                                                .id);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                      );
                    }),
              ],
            )));
  }

  Widget _composeFinished(Map<String, dynamic> mapResponse) {
    if (mapResponse['code'] == 200) {
      _fevListBloc.getReceivedMessages();
    } else {
      _widgetsCollection.showToastMessage(mapResponse['content']['message']);
    }
    return Container(width: 0.0, height: 0.0);
  }
}
