import 'package:articles/bloc_patterns/articles/view_article_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuthorDetailsTab extends StatefulWidget {
  AuthorDetailsTab({this.id});
  final String id;
  @override
  _AuthorDetailsTabState createState() => _AuthorDetailsTabState();
}

class _AuthorDetailsTabState extends State<AuthorDetailsTab>
    with AutomaticKeepAliveClientMixin {
  final ViewArticleBloc _viewArticleBloc = ViewArticleBloc();
  DateFormat _dateFormat = DateFormat('MMM dd yyyy');

  @override
  void initState() {
    _viewArticleBloc.getAuthorDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
      child: StreamBuilder(
          stream: _viewArticleBloc.tabProfileStream,
          builder: (BuildContext contexts,
              AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
            return asyncSnapshot.data == null
                ? Container(
                    child: Center(
                      child: Text("Loading...."),
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Full Name',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 3.0),
                                child: Text(
                                    '${asyncSnapshot.data['firstName']} ${asyncSnapshot.data['lastName']}'))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Gender',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 3.0),
                                child: Text("${asyncSnapshot.data['gender']}"))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date of Birth',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 3.0),
                                child: Text(
                                    "${_dateFormat.format(DateTime.parse(asyncSnapshot.data['dateOfBirth']))}"))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Email Address',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 3.0),
                                child: Text(
                                    "${asyncSnapshot.data['username']}@mesbro.com",
                                    style: TextStyle()))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date of Joining',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 3.0),
                                child: Text(
                                    "${_dateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data['addedAt']))}",
                                    style: TextStyle()))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date of Joining',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 3.0),
                                child: Text(
                                    "${_dateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data['lastModifiedAt']))}",
                                    style: TextStyle()))
                          ],
                        ),
                      ),
                    ],
                  );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
