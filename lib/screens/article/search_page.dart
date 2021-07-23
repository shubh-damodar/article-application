import 'package:articles/bloc_patterns/articles/view_article_bloc.dart';
import 'package:articles/models/articles.dart';
import 'package:articles/screens/article/View_Article/view_article_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:articles/bloc_patterns/articles/search_bloc.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/utils/date_category.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/widgets_collection.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  SearchPage({this.articleList, this.articleType, this.jsonMap});

  List<Article> articleList = List<Article>();
  String articleType;
  Map jsonMap;

  _SearchPageState createState() => _SearchPageState(jsonMap: this.jsonMap);
}

class _SearchPageState extends State<SearchPage> {
  _SearchPageState({this.jsonMap});

  final Map jsonMap;

  DateCategory _dateCategory = DateCategory();
  NavigationActions _navigationActions;
  double _screenWidth, _screenHeight;
  final ScrollController _scrollController = ScrollController();
  SearchBloc _searchBloc;
  final ViewArticleBloc _viewArticleBloc = ViewArticleBloc();
  WidgetsCollection _widgetsCollection;

  void _onWillPop() async {
    _navigationActions.closeDialog();
  }

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _searchBloc = SearchBloc(articleSearchList: widget.articleList);
  }

  void dispose() {
    super.dispose();
    _searchBloc.dispose();
    _scrollController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: StreamBuilder(
            stream: _searchBloc.articleSubjectShortTextStream,
            builder:
                (BuildContext context, AsyncSnapshot<String> asyncSnapshot) {
              return Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: TextField(
                    autofocus: true,
                    onChanged: (String value) {
                      _searchBloc.searchBox(value);
                    },
                    decoration: InputDecoration(
                      prefix: Container(
                          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.deepOrange,
                            ),
                            onPressed: _onWillPop,
                          )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.deepOrange,
                      )),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.15),
                      hintText: 'Search....',
                    ),
                  ));
            }),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 1.0),
        child: StreamBuilder(
            stream: _searchBloc.articlesFoundStream,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                child: Text('No Search List Found....'),
                              ))
                            : ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: asyncSnapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _navigationActions.navigateToScreenWidget(
                                          ViewArticle(
                                              id: asyncSnapshot.data[index].id,
                                              previousScreen: 'explore_page'));
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
                                                        tag:    "TagList${asyncSnapshot.data[index].thumbnail}",
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
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
                                                                      top: 4.0),
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
                                                      255, 51, 51, 51)),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: GestureDetector(
                                                      child: Icon(
                                                        Icons.star,
                                                        size: 17,
                                                        color: Colors.white,
                                                      ),
                                                      onTap: () {
                                                        _viewArticleBloc
                                                            .markUnmarkFavorite(
                                                                '${asyncSnapshot.data[index].id}',
                                                                "add");
                                                        _widgetsCollection
                                                            .showToastMessage(
                                                                "Added To Favourite");
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: GestureDetector(
                                                      child: Icon(
                                                        Icons.watch_later,
                                                        size: 17,
                                                        color: Colors.white,
                                                      ),
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
