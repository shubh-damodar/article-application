import 'package:articles/bloc_patterns/articles/view_article_bloc.dart';
import 'package:articles/models/articles.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/widgets_collection.dart';
import 'package:flutter/material.dart';

class CommentTab extends StatefulWidget {
  CommentTab({this.id});

  final String id;

  @override
  _CommentTabState createState() => _CommentTabState();
}

class _CommentTabState extends State<CommentTab> {
  final GlobalKey<FormState> _comment = GlobalKey<FormState>();
  TextEditingController _commentArticleTextEditingController =
      TextEditingController();

  NavigationActions _navigationActions;
  final ViewArticleBloc _viewArticleBloc = ViewArticleBloc();
  WidgetsCollection _widgetsCollection;

  @override
  void dispose() {
    _viewArticleBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _viewArticleBloc.getCommentList(widget.id);
  }

  Widget _composeFinished(Map<String, dynamic> mapResponse) {
    // _viewArticleBloc.getCommentList(widget.id);
    if (mapResponse['code'] == 200) {
      setState(() {
        _viewArticleBloc.getCommentList(widget.id);
      });
    } else {
      _widgetsCollection.showToastMessage(mapResponse['content']['message']);
    }
    return Container(width: 0.0, height: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: _viewArticleBloc.composeFinishedStream,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
              return asyncSnapshot.data == null
                  ? Container(width: 0.0, height: 0.0)
                  : asyncSnapshot.data.length == 0
                      ? Container(width: 0.0, height: 0.0)
                      : _composeFinished(asyncSnapshot.data);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Container(
                child: Form(
              autovalidate: false,
              key: _comment,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      maxLines: 2,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Your Comment here',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              fontFamily: 'Poppins')),
                      controller: _commentArticleTextEditingController,
                      validator: (String value) {
                        if (value.length < 1) {
                          return 'At least 1 charactor Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          color: Colors.deepOrange,
                          onPressed: () {
                            if (_comment.currentState.validate()) {
                              _viewArticleBloc.commentArticle(widget.id,
                                  _commentArticleTextEditingController.text);
                              _commentArticleTextEditingController.clear();
                              _widgetsCollection.showToastMessage("Commented");
                            }
                          },
                          child: Text(
                            "Comment",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                ],
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Comments",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: _viewArticleBloc.commentsListStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Article>> asyncSnapshot) {
                      return asyncSnapshot.data == null
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : asyncSnapshot.data.length == 0
                              ? Container(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text("No Comments...."),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 300,
                                  child: ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            Divider(
                                      color: Colors.black12,
                                    ),
                                    shrinkWrap: false,
                                    itemCount: asyncSnapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return asyncSnapshot.data.length == null
                                          ? Container(
                                              child:
                                                  Center(child: Text("data")),
                                            )
                                          : Column(
                                              children: <Widget>[
                                                ListTile(
                                                    title: Text(
                                                      '${asyncSnapshot.data[index].addedBy}',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          asyncSnapshot.data ==
                                                                  null
                                                              ? ""
                                                              : asyncSnapshot
                                                                          .data
                                                                          .length >
                                                                      50
                                                                  ? "${asyncSnapshot.data[index].details.substring(0, 50)}"
                                                                  : asyncSnapshot
                                                                      .data[
                                                                          index]
                                                                      .details,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        asyncSnapshot
                                                                    .data[index]
                                                                    .repliesCount ==
                                                                0
                                                            ? Container()
                                                            : GestureDetector(
                                                                child:
                                                                    Container(
                                                                  child: Text(
                                                                    'Show ${asyncSnapshot.data[index].repliesCount} Replies',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            13.0,
                                                                        color: Colors
                                                                            .black38),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  _viewArticleBloc.getCommentListNasted(
                                                                      asyncSnapshot
                                                                          .data[
                                                                              index]
                                                                          .commentid);
                                                                  setState(() {
                                                                    StreamBuilder(
                                                                        stream: _viewArticleBloc
                                                                            .commentsListNatedStream,
                                                                        builder: (BuildContext
                                                                                context,
                                                                            AsyncSnapshot<List<Article>>
                                                                                asyncSnapshot) {
                                                                          return ListView
                                                                              .separated(
                                                                            separatorBuilder: (BuildContext context, int index) =>
                                                                                Divider(
                                                                              color: Colors.black12,
                                                                            ),
                                                                            shrinkWrap:
                                                                                false,
                                                                            itemCount:
                                                                                asyncSnapshot.data.length,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              return asyncSnapshot.data.length == null
                                                                                  ? Container(
                                                                                      child: Center(child: Text("data")),
                                                                                    )
                                                                                  : Column(
                                                                                      children: <Widget>[
                                                                                        ListTile(
                                                                                          title: Text(
                                                                                            '${asyncSnapshot.data[index].addedBy}',
                                                                                            style: TextStyle(fontSize: 12),
                                                                                          ),
                                                                                          subtitle: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: <Widget>[
                                                                                              Text(
                                                                                                '${asyncSnapshot.data[index].details}',
                                                                                                style: TextStyle(fontSize: 12),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          trailing: FlatButton.icon(
                                                                                            label: Text("${asyncSnapshot.data[index].likes}"),
                                                                                            icon: asyncSnapshot.data[index].hasLiked
                                                                                                ? Icon(Icons.thumb_up, color: Colors.red, size: 15.0)
                                                                                                : Icon(
                                                                                                    Icons.thumb_up,
                                                                                                    color: Colors.grey,
                                                                                                    size: 15.0,
                                                                                                  ),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                asyncSnapshot.data[index].hasLiked = !asyncSnapshot.data[index].hasLiked;
                                                                                              });
                                                                                              asyncSnapshot.data[index].hasLiked
                                                                                                  ? _viewArticleBloc.commentLike(asyncSnapshot.data[index].commentid, widget.id, "like")
                                                                                                  : _viewArticleBloc.commentLike(
                                                                                                      asyncSnapshot.data[index].commentid,
                                                                                                      widget.id,
                                                                                                      "unlike",
                                                                                                    );

                                                                                              asyncSnapshot.data[index].hasLiked
                                                                                                  ? _widgetsCollection.showToastMessage("Liked")
                                                                                                  : _widgetsCollection.showToastMessage(
                                                                                                      'Unliked',
                                                                                                    );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                            },
                                                                          );
                                                                        });
                                                                  });
                                                                },
                                                              ),
                                                      ],
                                                    ),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        IconButton(
                                                          icon: asyncSnapshot
                                                                  .data[index]
                                                                  .hasLiked
                                                              ? Icon(
                                                                  Icons
                                                                      .thumb_up,
                                                                  color: Colors
                                                                      .deepOrange,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .thumb_up,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                          iconSize: 15,
                                                          onPressed: () {
                                                            setState(() {
                                                              asyncSnapshot
                                                                      .data[index]
                                                                      .hasLiked =
                                                                  !asyncSnapshot
                                                                      .data[
                                                                          index]
                                                                      .hasLiked;
                                                            });
                                                            asyncSnapshot
                                                                    .data[index]
                                                                    .hasLiked
                                                                ? _viewArticleBloc.commentLike(
                                                                    asyncSnapshot
                                                                        .data[
                                                                            index]
                                                                        .commentid,
                                                                    widget.id,
                                                                    "like")
                                                                : _viewArticleBloc.commentLike(
                                                                    asyncSnapshot
                                                                        .data[
                                                                            index]
                                                                        .commentid,
                                                                    widget.id,
                                                                    "unlike");

                                                            asyncSnapshot
                                                                    .data[index]
                                                                    .hasLiked
                                                                ? _widgetsCollection
                                                                    .showToastMessage(
                                                                        "Liked")
                                                                : _widgetsCollection
                                                                    .showToastMessage(
                                                                        'Unliked');
                                                          },
                                                        ),
                                                        Text(
                                                            "${asyncSnapshot.data[index].likes}")
                                                      ],
                                                    )
                                                    //  FlatButton.icon(
                                                    //   label: Text(
                                                    //       "${asyncSnapshot.data[index].likes}"),
                                                    //   icon: asyncSnapshot
                                                    //           .data[index]
                                                    //           .hasLiked
                                                    //       ? Icon(Icons.thumb_up,
                                                    //           color: Colors.red,
                                                    //           size: 15.0)
                                                    //       : Icon(Icons.thumb_up,
                                                    //           color: Colors.grey,
                                                    //           size: 15.0),
                                                    //   onPressed: () {
                                                    //     setState(() {
                                                    //       asyncSnapshot
                                                    //               .data[index]
                                                    //               .hasLiked =
                                                    //           !asyncSnapshot
                                                    //               .data[index]
                                                    //               .hasLiked;
                                                    //     });
                                                    //     asyncSnapshot.data[index]
                                                    //             .hasLiked
                                                    //         ? _viewArticleBloc
                                                    //             .commentLike(
                                                    //                 asyncSnapshot
                                                    //                     .data[
                                                    //                         index]
                                                    //                     .commentid,
                                                    //                 widget.id,
                                                    //                 "like")
                                                    //         : _viewArticleBloc
                                                    //             .commentLike(
                                                    //                 asyncSnapshot
                                                    //                     .data[
                                                    //                         index]
                                                    //                     .commentid,
                                                    //                 widget.id,
                                                    //                 "unlike");

                                                    //     asyncSnapshot.data[index]
                                                    //             .hasLiked
                                                    //         ? _widgetsCollection
                                                    //             .showToastMessage(
                                                    //                 "Liked")
                                                    //         : _widgetsCollection
                                                    //             .showToastMessage(
                                                    //                 'Unliked');
                                                    //   },
                                                    // ),
                                                    ),
                                                // isOpened == true
                                                // ? Padding(
                                                //     padding:
                                                //         const EdgeInsets
                                                //                 .only(
                                                //             left: 15.0),
                                                //     child: Column(
                                                //       children: <Widget>[
                                                //         Row(
                                                //           children: <
                                                //               Widget>[
                                                //             GestureDetector(
                                                //               child: Icon(
                                                //                 Icons
                                                //                     .reply,
                                                //                 size: 18,
                                                //               ),
                                                //               onTap: () {
                                                //                 setState(
                                                //                     () {
                                                //                   isOpened =
                                                //                       false;
                                                //                 });
                                                //               },
                                                //             ),
                                                //           ],
                                                //         ),
                                                //         Container(
                                                //           padding: EdgeInsets
                                                //               .only(
                                                //                   right:
                                                //                       20.0,
                                                //                   left:
                                                //                       20),
                                                //           child:
                                                //               TextField(
                                                //             controller:
                                                //                 _replyOnComments,
                                                //             decoration:
                                                //                 InputDecoration(
                                                //               labelText:
                                                //                   'Reply on Comment..',
                                                //               labelStyle: TextStyle(
                                                //                   fontSize:
                                                //                       12,
                                                //                   color: Colors
                                                //                       .grey),
                                                //             ),
                                                //           ),
                                                //         ),
                                                //         Row(
                                                //           mainAxisAlignment:
                                                //               MainAxisAlignment
                                                //                   .end,
                                                //           children: <
                                                //               Widget>[
                                                //             Padding(
                                                //               padding: const EdgeInsets
                                                //                       .only(
                                                //                   right:
                                                //                       20.0),
                                                //               child:
                                                //                   RaisedButton(
                                                //                 color: Colors
                                                //                     .deepOrange,
                                                //                 onPressed:
                                                //                     () {
                                                //                   _viewArticleBloc.commentReply(
                                                //                       asyncSnapshot.data[index].commentid,
                                                //                       widget.id,
                                                //                       _replyOnComments.text);
                                                //                   _replyOnComments
                                                //                       .clear();
                                                //                 },
                                                //                 child:
                                                //                     Text(
                                                //                   "Commment",
                                                //                   style: TextStyle(
                                                //                       fontSize:
                                                //                           10,
                                                //                       color:
                                                //                           Colors.white),
                                                //                 ),
                                                //               ),
                                                //             ),
                                                //           ],
                                                //         )
                                                //       ],
                                                //     ),
                                                //   )
                                                // : Padding(
                                                //     padding:
                                                //         const EdgeInsets
                                                //                 .only(
                                                //             left: 15.0),
                                                //     child: Column(
                                                //       children: <Widget>[
                                                //         Row(
                                                //           children: <
                                                //               Widget>[
                                                //             GestureDetector(
                                                //               child: Icon(
                                                //                 Icons
                                                //                     .reply,
                                                //                 size: 18,
                                                //               ),
                                                //               onTap: () {
                                                //                 setState(
                                                //                     () {
                                                //                   isOpened =
                                                //                       true;
                                                //                 });
                                                //               },
                                                //             ),
                                                //           ],
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   )
                                              ],
                                            );
                                    },
                                  ),
                                );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
