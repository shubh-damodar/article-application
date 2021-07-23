import 'package:articles/bloc_patterns/articles/explore_bloc.dart';
import 'package:articles/bloc_patterns/articles/view_article_bloc.dart';
import 'package:articles/screens/article/favourite_page.dart';
import 'package:articles/screens/article/my_articles_page.dart';
import 'package:articles/screens/article/read_later_page.dart';
import 'package:articles/screens/article/View_Article/view_article_page.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:articles/models/user.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/screens/idm/login_page.dart';
import 'package:articles/screens/article/search_page.dart';
import 'package:articles/screens/profile_screens/edit_profile_screens/profile_page.dart';
import 'package:articles/utils/date_category.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/network_connectivity.dart';
import 'package:articles/utils/shared_pref_manager.dart';
import 'package:articles/utils/widgets_collection.dart';
import '../../models/articles.dart';
import 'package:shimmer/shimmer.dart';

class ExploreArticlePage extends StatefulWidget {
  final Article articleId;
  ExploreArticlePage({this.articleId});
  _ExploreArticlePageState createState() => _ExploreArticlePageState();
}

class _ExploreArticlePageState extends State<ExploreArticlePage> {
  final ExploreArticleBloc _articleBloc = ExploreArticleBloc();
  DateCategory _dateCategory = DateCategory();
  double _screenWidth, _screenHeight;
  DateTime currentBackPressDateTime;
  List<User> _usersList = List<User>();
  int currentPageNumber;
  final ViewArticleBloc _viewArticleBloc = ViewArticleBloc();
  bool fev = false, time = false, tumbsUp = false;
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  final ScrollController _scrollController = ScrollController();
  Map _jsonMap = {
    "type": ["INBOX"]
  };

  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _articleBloc.getReceivedArticle();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _articleBloc.articleList.length % 5 == 0) {
        for (int i = 1; i < _articleBloc.articleList.length; i++) {
          _articleBloc.getFurtherMessages(i);
        }
      }
    });
    super.initState();
  }

  void dispose() {
    _articleBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAllUsers() async {
    await SharedPrefManager.getAllUsers().then((List<User> user) {
      setState(() {
        _usersList = user;
      });
    });
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressDateTime == null ||
        now.difference(currentBackPressDateTime) > Duration(seconds: 2)) {
      currentBackPressDateTime = now;
      _widgetsCollection.showToastMessage('Press once again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Explore',
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 16.0,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.deepOrange,
              ),
              onPressed: () {
                setState(() {
                  _navigationActions.navigateToScreenWidget(SearchPage(
                    articleList: _articleBloc.articleList,
                    articleType: 'input',
                    jsonMap: _jsonMap,
                  ));
                });
              },
            ),
          ],
        ),
        drawer: Container(
          color: Colors.deepOrange,
          width: _screenWidth * 0.90,
          child: Row(children: <Widget>[
            Flexible(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    color: Colors.grey.withOpacity(0.25),
                    child: ListView(
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _usersList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: _widgetsCollection.getDrawerProfileImage(
                                  45.0, _usersList[index]),
                              onTap: () {
                                setState(() {
                                  SharedPrefManager.switchCurrentUser(
                                          _usersList[index])
                                      .then((value) {
                                    _navigationActions
                                        .navigateToScreenWidget(ProfilePage(
                                      userId: Connect.currentUser.userId,
                                    ));
                                  });
                                });
                              },
                            );
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          padding: EdgeInsets.all(0.5),
                          width: 45.0,
                          height: 45.0,
                          child: Center(
                            child: ClipOval(
                              child: IconButton(
                                  icon: Icon(Icons.person_add),
                                  onPressed: () {
                                    _navigationActions.navigateToScreenWidget(
                                        LoginPage(
                                            previousScreen: 'explore_page'));
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Flexible(
              flex: 7,
              child: Drawer(
                elevation: 1.0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    DrawerHeader(
                      child: Image.asset(
                        'assets/images/mesbro.png',
                        width: _screenWidth * 0.4,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.explore),
                      title: Text('My Article', style: TextStyle()),
                      onTap: () {
                        _navigationActions.navigateToScreenWidget(
                          MyArticlesPage(
                            userId: Connect.currentUser.userId,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.mail),
                      title: Text('Read Later', style: TextStyle()),
                      onTap: () {
                        _navigationActions
                            .navigateToScreenWidget(ReadLaterPage());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_size_select_actual),
                      title: Text('Favourite Articles', style: TextStyle()),
                      onTap: () {
                        _navigationActions
                            .navigateToScreenWidget(FavouriteArticlePage());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Log Out'),
                      onTap: () {
                        SharedPrefManager.removeAll().then(
                          (bool value) {
                            _navigationActions
                                .navigateToScreenWidgetRoot(LoginPage());
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Version: 0.0.8',
                            style: TextStyle(
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        body: StreamBuilder(
            stream: _articleBloc.articlesStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<Article>> asyncSnapshot) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: asyncSnapshot.data == null
                        ? new LoadingScreen(screenWidth: _screenWidth)
                        : asyncSnapshot.data.length == 0
                            ? Container(
                                child: Center(
                                child: Text('No Article...'),
                              ))
                            : ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: false,
                                itemCount: asyncSnapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _navigationActions
                                          .navigateToScreenWidget(ViewArticle(
                                        userId: Connect.currentUser.userId,
                                        id: asyncSnapshot.data[index].id,
                                        previousScreen: 'explore_page',
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
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
                                                        tag:
                                                            "TagList${asyncSnapshot.data[index].thumbnail}",
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
                                                                .only(left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
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
                                                                    color: Color
                                                                        .fromARGB(
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
                                                                            4.0),
                                                                child: Text(
                                                                    '${asyncSnapshot.data[index].shortDescription}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13.0,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            112,
                                                                            122,
                                                                            112)))),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 6.0,
                                                                      bottom:
                                                                          7.0),
                                                                  child: Text(
                                                                    '${asyncSnapshot.data[index].addedBy}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          51,
                                                                          51,
                                                                          51),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
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
                                            bottom: 11,
                                            right: 15,
                                            child: Text(
                                              '${_dateCategory.MMMMddDateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data[index].addedAt))}',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 51, 51, 51),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: Card(
                                              margin: EdgeInsets.all(5),
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Icon(
                                                            Icons.watch_later,
                                                            size: 17,
                                                            color:
                                                                Colors.white)),
                                                    onTap: () {
                                                      _viewArticleBloc
                                                          .timeMarkWatch(
                                                              '${asyncSnapshot.data[index].id}',
                                                              "add");
                                                      _widgetsCollection
                                                          .showToastMessage(
                                                              "Add To Read Later");
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Icon(Icons.star,
                                                            size: 17,
                                                            color:
                                                                Colors.white)),
                                                    onTap: () {
                                                      _viewArticleBloc
                                                          .markUnmarkFavorite(
                                                              '${asyncSnapshot.data[index].id}',
                                                              "add");
                                                      _widgetsCollection
                                                          .showToastMessage(
                                                              "Added To Favourite");
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key key,
    @required double screenWidth,
  })  : _screenWidth = screenWidth,
        super(key: key);

  final double _screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Column(
          children: [0, 1, 2, 3]
              .map(
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: _screenWidth,
                        height: 150.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
