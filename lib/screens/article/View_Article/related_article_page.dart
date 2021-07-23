import 'package:articles/bloc_patterns/articles/view_article_bloc.dart';
import 'package:articles/models/articles.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/screens/article/View_Article/view_article_page.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RelatedArticle extends StatefulWidget {
  RelatedArticle({this.id});
  final String id;
  @override
  _RelatedArticleState createState() => _RelatedArticleState();
}

class _RelatedArticleState extends State<RelatedArticle> {
  NavigationActions _navigationActions;
  final ViewArticleBloc _viewArticleBloc = ViewArticleBloc();
  double _width, _height;

  @override
  void initState() {
    _viewArticleBloc.getAllRealtedArticle(widget.id);
    _navigationActions = NavigationActions(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: _viewArticleBloc.listArticleStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Article>> asyncSnapshot) {
          return asyncSnapshot.data == null
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Row(
                      children: [0, 1]
                          .map(
                            (_) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: _width / 2.5,
                                    height: 100.0,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
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
              : Container(
                  height: _height / 4,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: EdgeInsets.all(5),
                    shrinkWrap: true,
                    itemCount: asyncSnapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        onTap: () {
                          _navigationActions.navigateToScreenWidget(ViewArticle(
                            id: asyncSnapshot.data[index].id,
                          ));
                        },
                        child: Card(
                          elevation: 3,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: _width / 1.9,
                                      height: _height / 8,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: _width,
                                        imageUrl:
                                            "${Connect.filesUrl}${asyncSnapshot.data[index].thumbnail}",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        width: _width / 2.2,
                                        height: 20,
                                        child: Text(
                                          "${asyncSnapshot.data[index].title}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Container(
                                            width: _width / 2,
                                            child: Text(
                                              '${asyncSnapshot.data[index].shortDescription}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      width: _width / 2,
                                      child: Text(
                                        '${asyncSnapshot.data[index].name}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
        });
  }
}
