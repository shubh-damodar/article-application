import 'package:articles/bloc_patterns/edit_profile_bloc_patterns/profile_bloc.dart';
import 'package:articles/screens/article/View_Article/related_article_page.dart';
import 'package:articles/screens/article/View_Article/tabs/author_details_tab.dart';
import 'package:articles/screens/article/View_Article/tabs/comment_tab.dart';
import 'package:articles/screens/article/View_Article/tabs/report_tab.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:articles/bloc_patterns/articles/view_article_bloc.dart';
import 'package:articles/models/user.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/network_connectivity.dart';
import 'package:articles/utils/shared_pref_manager.dart';
import 'package:articles/utils/widgets_collection.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class ViewArticle extends StatefulWidget {
  ViewArticle({this.id, this.previousScreen, this.userId});

  final String id, previousScreen, userId;

  _ViewArticleState createState() => _ViewArticleState();
}

class _ViewArticleState extends State<ViewArticle>
    with SingleTickerProviderStateMixin {
  DateTime currentBackPressDateTime;
  bool fev = false,
      time = false,
      tumbsUp = false,
      subcribe = false,
      tumbsDown = false,
      dontKnowThumb = false,
      isOpened = false,
      commentTumbsup = false;

  Map<String, dynamic> sentUserMap;
  String userId;

  final GlobalKey<FormState> _comment = GlobalKey<FormState>(),
      _report = GlobalKey<FormState>();

  // TextEditingController _commentArticleTextEditingController =
  //         TextEditingController(),
  //     _reportArticleTextEditingController = TextEditingController(),
  //     _replyOnComments = TextEditingController();

  DateFormat _dateFormat = DateFormat('MMM dd yyyy');
  double _height;
  NavigationActions _navigationActions;
  final ProfileBloc _profileBloc = ProfileBloc();
  double _screenWidth, _screenHeight;
  final ScrollController _scrollController = ScrollController();
  TabController _tabController;
  final ViewArticleBloc _viewArticleBloc = ViewArticleBloc();
  List<User> _usersList = List<User>();
  WidgetsCollection _widgetsCollection;
  double _width;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _viewArticleBloc.getAllUserDetails(widget.id);
    _profileBloc.getAllUserDetails(userId);
  }

  void dispose() {
    super.dispose();
    _tabController.dispose();
    _viewArticleBloc.dispose();
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
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Article',
          style: TextStyle(color: Colors.deepOrange, fontSize: 16.0),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 5),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: _viewArticleBloc.thumbnailStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> asyncSnapshot) {
                        return asyncSnapshot.data == null
                            ? Image.asset(
                                'assets/images/cover3.jpg',
                                width: double.infinity,
                                height: 200.0,
                                fit: BoxFit.cover,
                              )
                            : Column(
                                children: <Widget>[
                                  Hero(
                                    tag: "TagList${asyncSnapshot.data}",
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${Connect.filesUrl}${asyncSnapshot.data}",
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                    ),
                                  )
                                ],
                              );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                            stream: _viewArticleBloc.titleStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              return Expanded(
                                child: ListTile(
                                  title: StreamBuilder(
                                      stream: _viewArticleBloc.titleStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> asyncSnapshot) {
                                        return Text(
                                          asyncSnapshot.data == null
                                              ? 'Loading.....'
                                              : "${asyncSnapshot.data}",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        );
                                      }),
                                  subtitle: StreamBuilder(
                                      stream: _viewArticleBloc.addedAtStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> asyncSnapshot) {
                                        return Text(
                                            asyncSnapshot.data == null
                                                ? 'Loading...'
                                                : "Published on ${asyncSnapshot.data}",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ));
                                      }),
                                ),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0),
                          child: Row(
                            children: <Widget>[
                              StreamBuilder(
                                  stream: _viewArticleBloc.subscribeStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> asyncSnapshot) {
                                    return asyncSnapshot.data == !subcribe
                                        ? RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: StreamBuilder(
                                                stream: _viewArticleBloc
                                                    .subscribersStream,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<String>
                                                        asyncSnapshot) {
                                                  return Text(
                                                    asyncSnapshot.data == null
                                                        ? "Loading...."
                                                        : "${asyncSnapshot.data} Unsubscribe",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  );
                                                }),
                                            color: Colors.grey,
                                            onPressed: () {
                                              subcribe = !subcribe;
                                              _widgetsCollection
                                                  .showToastMessage(
                                                      "Unsubscribe");
                                              setState(() {
                                                _viewArticleBloc
                                                    .articleAssessSubscription(
                                                        widget.id,
                                                        "unsubscribe");
                                              });
                                            },
                                          )
                                        : RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: StreamBuilder(
                                                stream: _viewArticleBloc
                                                    .subscribersStream,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<String>
                                                        asyncSnapshot) {
                                                  return Text(
                                                    asyncSnapshot.data == null
                                                        ? "Loading...."
                                                        : "${asyncSnapshot.data} Subscribe",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  );
                                                }),
                                            color: Colors.deepOrange,
                                            onPressed: () {
                                              subcribe = !subcribe;
                                              _widgetsCollection
                                                  .showToastMessage(
                                                      "Subscribe");
                                              setState(() {
                                                _viewArticleBloc
                                                    .articleAssessSubscription(
                                                        widget.id, "subscribe");
                                              });
                                            },
                                          );
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      StreamBuilder(
                          stream: _viewArticleBloc.watchLaterStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> asyncSnapshot) {
                            return asyncSnapshot.data == null
                                ? IconButton(
                                    icon: Icon(
                                      Icons.cached,
                                      color: Colors.grey,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      _widgetsCollection
                                          .showToastMessage("No Internet.....");
                                    },
                                  )
                                : IconButton(
                                    icon: asyncSnapshot.data == !time
                                        ? Icon(Icons.access_time,
                                            color: Colors.deepOrange,
                                            size: 20.0)
                                        : Icon(Icons.access_time,
                                            color: Colors.grey, size: 20.0),
                                    onPressed: () {
                                      asyncSnapshot.data == !time
                                          ? _widgetsCollection.showToastMessage(
                                              "Removed from Read Later")
                                          : _widgetsCollection.showToastMessage(
                                              "Added to Read Later");
                                      time = !time;
                                      setState(() {
                                        asyncSnapshot.data == !time
                                            ? _viewArticleBloc.timeMarkWatch(
                                                widget.id, 'add')
                                            : _viewArticleBloc.timeMarkWatch(
                                                widget.id, "remove");
                                      });
                                    },
                                  );
                          }),
                      StreamBuilder(
                          stream: _viewArticleBloc.fevarticleStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> asyncSnapshot) {
                            return asyncSnapshot.data == null
                                ? IconButton(
                                    icon: Icon(
                                      Icons.cached,
                                      color: Colors.grey,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      _widgetsCollection
                                          .showToastMessage("No Internet.....");
                                    },
                                  )
                                : IconButton(
                                    icon: asyncSnapshot.data == !fev
                                        ? Icon(Icons.star,
                                            color: Colors.deepOrange,
                                            size: 20.0)
                                        : Icon(Icons.star_border,
                                            color: Colors.grey, size: 20.0),
                                    onPressed: () {
                                      asyncSnapshot.data == !fev
                                          ? _widgetsCollection.showToastMessage(
                                              "Removed from Favourite ")
                                          : _widgetsCollection.showToastMessage(
                                              "Added to Favourite");
                                      fev = !fev;
                                      setState(() {
                                        asyncSnapshot.data == !fev
                                            ? _viewArticleBloc
                                                .markUnmarkFavorite(
                                                    widget.id, 'add')
                                            : _viewArticleBloc
                                                .markUnmarkFavorite(
                                                    widget.id, "remove");
                                      });
                                    },
                                  );
                          }),
                      StreamBuilder(
                          stream: _viewArticleBloc.hasLikedStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> asyncSnapshot) {
                            return FlatButton.icon(
                              color: Colors.white.withOpacity(0),
                              icon: Icon(
                                asyncSnapshot.data == null
                                    ? Icons.cached
                                    : Icons.thumb_up,
                                color: asyncSnapshot.data == !tumbsUp
                                    ? Colors.deepOrange
                                    : Colors.grey,
                                size: 20,
                              ),
                              label: StreamBuilder(
                                  stream: _viewArticleBloc.likesStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> asyncSnapshot) {
                                    return Text(
                                      asyncSnapshot.data == null
                                          ? '0'
                                          : "${asyncSnapshot.data}",
                                      style: TextStyle(color: Colors.grey),
                                    );
                                  }),
                              onPressed: () {
                                setState(() {
                                  _viewArticleBloc.likeArticle(
                                      widget.id, "like");
                                });
                              },
                            );
                          }),
                      StreamBuilder(
                          stream: _viewArticleBloc.hasUnlikedStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> asyncSnapshot) {
                            return FlatButton.icon(
                              color: Colors.white.withOpacity(0),
                              icon: Icon(
                                asyncSnapshot.data == null
                                    ? Icons.cached
                                    : Icons.thumb_down,
                                color: asyncSnapshot.data == !tumbsDown
                                    ? Colors.deepOrange
                                    : Colors.grey,
                                size: 20,
                              ),
                              label: StreamBuilder(
                                  stream: _viewArticleBloc.dislikesStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> asyncSnapshot) {
                                    return Text(
                                      asyncSnapshot.data == null
                                          ? '0'
                                          : "${asyncSnapshot.data}",
                                      style: TextStyle(color: Colors.grey),
                                    );
                                  }),
                              onPressed: () {
                                setState(() {
                                  _viewArticleBloc.likeArticle(
                                      widget.id, "unlike");
                                });
                              },
                            );
                          }),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          Share.share(
                              'https://www.mesbro.com/1/articles/view/${widget.id}');
                        },
                      )
                    ],
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        StreamBuilder(
                            stream: _viewArticleBloc.shortDescriptionStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              return asyncSnapshot.data == null
                                  ? Container(
                                      width: _width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 16.0),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300],
                                        highlightColor: Colors.grey[100],
                                        child: Column(
                                          children: [0, 1, 2, 3, 4]
                                              .map(
                                                (_) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: _width,
                                                        height: 100.0,
                                                        color: Colors.white,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "Published on : ${asyncSnapshot.data} ",
                                    );
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                        stream: _viewArticleBloc.contentStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> asyncSnapshot) {
                          return asyncSnapshot.data == null
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 16.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Column(
                                      children: [0, 1, 2, 3]
                                          .map(
                                            (_) => Padding(
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
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    HtmlWidget(
                                      "Published on ${asyncSnapshot.data} ",
                                    )
                                  ],
                                );
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      "Related Article",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  RelatedArticle(id: widget.id),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // padding: EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height / 1.9,
                    child: Column(
                      children: <Widget>[
                        TabBar(
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14.0),
                            indicatorColor: Colors.deepOrange,
                            labelColor: Colors.deepOrange,
                            unselectedLabelColor: Colors.grey,
                            controller: _tabController,
                            tabs: <Widget>[
                              Tab(text: 'Comments'),
                              Tab(text: 'Author Details'),
                              Tab(text: 'Report'),
                            ]),
                        Expanded(
                            child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            new CommentTab(id: widget.id),
                            new AuthorDetailsTab(id: widget.id),
                            new ReportTab(id: widget.id),
                          ],
                        ))
                      ],
                    ),
                  ),
                  // Column(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: EdgeInsets.only(left: 10),
                  //       child: Row(
                  //         children: <Widget>[
                  //           Text(
                  //             'Comments',
                  //             style: TextStyle(
                  //                 fontSize: 16, fontWeight: FontWeight.bold),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     CommentsList(id: widget.id),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
