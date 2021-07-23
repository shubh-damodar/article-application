import 'package:articles/bloc_patterns/articles/view_article_bloc.dart';
import 'package:articles/utils/widgets_collection.dart';
import 'package:flutter/material.dart';

class ReportTab extends StatefulWidget {
  ReportTab({this.id});
  final String id;
  @override
  _ReportTabState createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  final GlobalKey<FormState> _report = GlobalKey<FormState>();
  TextEditingController _reportArticleTextEditingController =
      TextEditingController();
  final ViewArticleBloc _viewArticleBloc = ViewArticleBloc();
  WidgetsCollection _widgetsCollection;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        autovalidate: false,
        key: _report,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Resone Max 200 characters',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          fontFamily: 'Poppins')),
                  controller: _reportArticleTextEditingController,
                  validator: (String value) {
                    if (value.length < 200) {
                      return "At least 200 characters required";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      onPressed: () {
                        _reportArticleTextEditingController.clear();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.deepOrange,
                      onPressed: () {
                        if (_report.currentState.validate()) {
                          _widgetsCollection.showToastMessage("Reported");
                          _viewArticleBloc.reportArticle(widget.id,
                              _reportArticleTextEditingController.text);
                          _reportArticleTextEditingController.clear();
                        }
                      },
                      child: Text(  
                        "Report",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
