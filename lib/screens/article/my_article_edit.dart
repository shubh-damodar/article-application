import 'dart:io';
import 'package:articles/bloc_patterns/articles/edit_article_bloc.dart';
import 'package:articles/bloc_patterns/edit_profile_bloc_patterns/profile_bloc.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/utils/data_collection.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/widgets_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EditArticlePage extends StatefulWidget {
  final String userId, previousScreen, title, shortDescription;
  EditArticlePage(
      {this.previousScreen, this.userId, this.title, this.shortDescription});
  _EditArticlePageState createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final GlobalKey<FormState> _editformKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  final ProfileBloc _profileBloc = ProfileBloc();
  final EditBloc _editBloc = EditBloc();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  DataCollection _dataCollection = DataCollection();
  String _htmlFilePath =
          'file:///android_asset/flutter_assets/assets/cks_code.html',
      userId,
      title,
      _selectedLanguage;
  Country _country;
  WebViewController _webViewController;
  TextEditingController _titleTextEditingController = TextEditingController(),
      countryCodeTextEditingController = TextEditingController(),
      _tagsTextEditingController = TextEditingController(),
      _shortDescriptionTextEditingController = TextEditingController();
  File image;

  @override
  void initState() {
    super.initState();
    _country = Country.IN;
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _selectedLanguage = null;
    _editBloc.getArticleDetails(widget.userId);
    userId = widget.userId;
  }

  @override
  void dispose() {
    super.dispose();
    _profileBloc.dispose();
    _editBloc.dispose();
  }

  takePicture() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    setState(() {
      _editBloc.takePicture(image);
    });
  }

  _imageBuilder(String data) {
    return CachedNetworkImage(
      imageUrl: data,
      fit: BoxFit.cover,
      height: 250,
      width: double.infinity,
    );
  }

  Future<bool> _onWillPop() async {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Do you want to Cancel Update?'),
            content: Text('Unsaved data will be lost!!'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  _navigationActions.previousScreenUpdate();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _deleteArticle() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this article?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              onPressed: () {
                _widgetsCollection.showMessageDialog();
                _navigationActions.previousScreenUpdate();
                _editBloc.deletMyArticle(widget.userId);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.white,
          title: Text('Modify article',
              style: TextStyle(color: Colors.deepOrange, fontSize: 16.0)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.deepOrange,
              ),
              onPressed: () {
                _deleteArticle();
              },
            ),
          ],
        ),
        body: Form(
            key: _editformKey,
            autovalidate: false,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: _editBloc.contentStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<String> asyncSnapshot) {
                      return asyncSnapshot.data == null
                          ? Container(width: 0.0, height: 0.0)
                          : _messageLoadingFinished(asyncSnapshot.data);
                    },
                  ),
                  // After delete  article show data
                  StreamBuilder(
                    stream: _editBloc.composeFinishedStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
                      return asyncSnapshot.data == null
                          ? Container(width: 0.0, height: 0.0)
                          : asyncSnapshot.data.length == 0
                              ? Container(width: 0.0, height: 0.0)
                              : _composeFinished(asyncSnapshot.data);
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 250,
                          width: double.infinity,
                          child: image == null
                              ? StreamBuilder(
                                  stream: _editBloc.thumbnailStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> asyncSnapshot) {
                                    return asyncSnapshot.data == null
                                        ? Container(
                                            width: 0,
                                            height: 0,
                                          )
                                        : Column(
                                            children: <Widget>[
                                              _imageBuilder(
                                                  '${Connect.filesUrl}${asyncSnapshot.data}')
                                            ],
                                          );
                                  })
                              : Image.file(
                                  image,
                                  height: 250.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Card(
                            margin: EdgeInsets.all(5),
                            color: Colors.black.withOpacity(0.4),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        takePicture();
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 20,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text(
                            "Article Name",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: StreamBuilder(
                      stream: _editBloc.titleStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> asyncSnapshot) {
                        asyncSnapshot.data == null
                            ? Container(
                                width: 0,
                                height: 0,
                              )
                            : _titleTextEditingController.value =
                                _titleTextEditingController.value
                                    .copyWith(text: asyncSnapshot.data);
                        return TextField(
                          controller: _titleTextEditingController,
                          onChanged: (String value) {
                            _editBloc.titleStreamSink.add(value);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Article Name',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins')),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Container(
                          child: Text(
                            "Select a Language",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 10),
                  //       child: Container(
                  //           child: DropdownButton<String>(
                  //               hint: Text(
                  //                 'Select a Language',
                  //                 style: TextStyle(),
                  //               ),
                  //               value: _selectedLanguage,
                  //               items: _dataCollection.languageList
                  //                   .map((String value) {
                  //                 return DropdownMenuItem(
                  //                   value: value,
                  //                   child: Text(
                  //                     value,
                  //                     style: TextStyle(
                  //                       fontWeight: FontWeight.w500,
                  //                       fontSize: 15.0,
                  //                     ),
                  //                   ),
                  //                 );
                  //               }).toList(),
                  //               onChanged: (String selectedValue) {
                  //                 setState(() {
                  //                   _selectedLanguage = selectedValue;
                  //                 });
                  //               })),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                            child: StreamBuilder(
                                stream: _editBloc.languageStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> asyncSnapshot) {
                                  return DropdownButton<String>(
                                      underline: Container(
                                        color: Colors.white,
                                      ),
                                      hint: Text(
                                        'Select Language',
                                        style: TextStyle(),
                                      ),
                                      value: asyncSnapshot.data == "null"
                                          ? null
                                          : asyncSnapshot.data,
                                      items: _dataCollection.languageList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String selectedValue) {
                                        _editBloc.languageStreamSink
                                            .add(selectedValue);
                                      });
                                })),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Container(
                          child: Text(
                            "Select a Country",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: CountryPicker(
                              showName: true,
                              onChanged: (Country selectedCountry) {
                                setState(() {
                                  _country = selectedCountry;
                                });
                              },
                              selectedCountry: _country)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text(
                            "Short Description",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: StreamBuilder(
                        stream: _editBloc.shortDescriptionStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> asyncSnapshot) {
                          asyncSnapshot.data == null
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : _shortDescriptionTextEditingController.value =
                                  _shortDescriptionTextEditingController.value
                                      .copyWith(text: asyncSnapshot.data);
                          return TextField(
                            onChanged: (String value) {
                              _editBloc.shortDescriptionStreamSink.add(value);
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Short Description',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    fontFamily: 'Poppins')),
                            controller: _shortDescriptionTextEditingController,
                          );
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text(
                            "Tags",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    child: StreamBuilder(
                        stream: _editBloc.listArticleTagsStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> asyncSnapshot) {
                          return asyncSnapshot.data == null
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: asyncSnapshot.data.length,
                                  // padding: EdgeInsets.all(5.0),
                                  padding: EdgeInsets.only(bottom: 5),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return asyncSnapshot.data.length == null
                                        ? Container(
                                            width: 0,
                                            height: 0,
                                          )
                                        : ChoiceChip(
                                            selected: _selectedIndex == null,
                                            label: GestureDetector(
                                              onTap: () {
                                                //todo create funtion to remove tag from tagStream
                                              },
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    '${asyncSnapshot.data[index]}',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  Icon(Icons.cancel)
                                                ],
                                              ),
                                            ));
                                  },
                                );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Tags',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              fontFamily: 'Poppins')),
                      controller: _tagsTextEditingController,
                      validator: (String value) {
                        if (value.length < 2) {
                          return 'Minimum Length should be at least 1 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text(
                            "Article Body",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          Container(
                              height: 400,
                              // margin: EdgeInsets.only(top: 50.0),
                              child: WebView(
                                  initialUrl: _htmlFilePath,
                                  javascriptMode: JavascriptMode.unrestricted,
                                  javascriptChannels: Set.from([
                                    _toasterJavascriptChannel(context),
                                    customImageChannel(context),
                                    ckEditorReadyChannel(context),
                                    ckContentUpdate(context)
                                  ]),
                                  onWebViewCreated:
                                      (WebViewController webViewController) {
                                    _webViewController = webViewController;
                                    _loadHtmlFromAssets();
                                  })),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                        child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.deepOrange,
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_editformKey.currentState.validate()) {
                          _widgetsCollection.showMessageDialog();
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          _editBloc.sendEditedArticale(
                            _titleTextEditingController.text,
                            _shortDescriptionTextEditingController.text,
                            _country.name,
                            _selectedLanguage,
                            _editBloc.htmlCode,
                            _tagsTextEditingController.text,
                            widget.userId,
                          );
                        }
                      },
                    )),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // print(message.message);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  JavascriptChannel ckEditorReadyChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'CkEditorReady',
        onMessageReceived: (JavascriptMessage message) {
          // print(message.message);
          String newFile = 'insertContent(`' + _editBloc.htmlCode + '`)';
          _webViewController.evaluateJavascript(newFile);
        });
  }

  JavascriptChannel ckContentUpdate(BuildContext context) {
    return JavascriptChannel(
        name: 'CkContentUpdate',
        onMessageReceived: (JavascriptMessage message) {
          // print(message.message);
          _editBloc.htmlCode = message.message;
        });
  }

  JavascriptChannel customImageChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'CkImage',
        onMessageReceived: (JavascriptMessage message) async {
          _webViewController.evaluateJavascript(_editBloc.htmlCode);
          if (message.message == 'select') {
            String test, newFile;
            test = "http://files.mesbro.com/icons/mesbro-logo.png";
            test = await _editBloc.appendImage();
            newFile = "insertImage('" + test + "')";
            _webViewController.evaluateJavascript(newFile);
          }
        });
  }

  Widget _composeFinished(Map<String, dynamic> mapResponse) {
    if (mapResponse['code'] == 200) {
      _navigationActions.closeDialog();
      _navigationActions.previousScreenUpdate();
      // _widgetsCollection.showToastMessage("${mapResponse['content']}");
    } else {
      _widgetsCollection.showToastMessage(mapResponse['content']['message']);
    }
    return Container(width: 0.0, height: 0.0);
  }

  Function modifyJS(String data) {
    _webViewController.evaluateJavascript(data);
  }

  _loadHtmlFromAssets() async {
    _webViewController.loadUrl(_htmlFilePath);
  }

  Widget _messageLoadingFinished(String data) {
    Future.delayed(Duration.zero, () {
      _editBloc.htmlCode = data;
    });
    return Container(width: 0.0, height: 0.0);
  }
}
