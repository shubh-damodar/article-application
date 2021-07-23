import 'dart:io';
import 'package:articles/bloc_patterns/articles/compose_article_bloc.dart';
import 'package:articles/bloc_patterns/edit_profile_bloc_patterns/profile_bloc.dart';
import 'package:articles/utils/data_collection.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/widgets_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ComposeArticlePage extends StatefulWidget {
  final String userId, previousScreen, title, shortDescription, id;
  ComposeArticlePage(
      {this.previousScreen,
      this.userId,
      this.title,
      this.shortDescription,
      this.id});

  _ComposeArticlePageState createState() => _ComposeArticlePageState();
}

class _ComposeArticlePageState extends State<ComposeArticlePage> {
  final GlobalKey<FormState> _composeformKey = GlobalKey<FormState>();
  final String previousScreen;
  _ComposeArticlePageState({this.previousScreen});
  final ProfileBloc _profileBloc = ProfileBloc();
  ComposeBloc _composeBloc = ComposeBloc();
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

  void initState() {
    super.initState();
    _country = Country.IN;
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _selectedLanguage = 'English';
    userId = widget.userId;
  }

  @override
  void dispose() {
    super.dispose();
    _profileBloc.dispose();
    _composeBloc.dispose();
  }

  takePicture() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    setState(() {
      _composeBloc.takePicture(image);
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Unsaved data will be lost.'),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.white,
          title: Text('Compose Article',
              style: TextStyle(color: Colors.deepOrange, fontSize: 16.0)),
          centerTitle: true,
        ),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
                key: _composeformKey,
                autovalidate: false,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 250,
                          child: image == null
                              ? Image.asset(
                                  'assets/images/cover3.jpg',
                                  width: double.infinity,
                                  height: 250.0,
                                  fit: BoxFit.cover,
                                )
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
                                        // size: .0,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
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
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _titleTextEditingController,
                      validator: (String value) {
                        if (value.length < 4 || value.length > 101) {
                          return 'Password should have characters between 3 and 100';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Article Name',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              fontFamily: 'Poppins')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 5),
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
                    Container(
                        child: DropdownButton<String>(
                            underline: Container(
                              color: Colors.transparent,
                            ),
                            value: null,
                            hint: Text("Select Language"),
                            items: _dataCollection.languageList
                                .map((String value) {
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
                              setState(() {
                                _selectedLanguage = selectedValue;
                              });
                            })),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 5),
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
                    Container(
                        margin: EdgeInsets.only(bottom: 10.0, top: 5),
                        child: CountryPicker(
                            showName: true,
                            onChanged: (Country selectedCountry) {
                              setState(() {
                                _country = selectedCountry;
                              });
                            },
                            selectedCountry: _country)),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
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
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Short Description',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              fontFamily: 'Poppins')),
                      controller: _shortDescriptionTextEditingController,
                      validator: (String value) {
                        if (value.length <= 200) {
                          return 'Minimum Length should be at least 200 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
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
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
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
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
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
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          Container(
                              height: 400,
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
                    SizedBox(
                      height: 20,
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
                          setState(() {
                            if (_composeformKey.currentState.validate()) {
                              _widgetsCollection.showMessageDialog();
                              _composeBloc.sendBodyMessage(
                                _titleTextEditingController.text,
                                _shortDescriptionTextEditingController.text,
                                _country.name,
                                _selectedLanguage,
                                _composeBloc.htmlCode,
                                _tagsTextEditingController.text,
                              );
                            }
                          });
                        },
                      )),
                    ),
                    StreamBuilder(
                      stream: _composeBloc.composeFinishedStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
                        return asyncSnapshot.data == null
                            ? Container(width: 0.0, height: 0.0)
                            : asyncSnapshot.data.length == 0
                                ? Container(width: 0.0, height: 0.0)
                                : _composeFinished(asyncSnapshot.data);
                      },
                    ),
                  ],
                ))),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  JavascriptChannel ckEditorReadyChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'CkEditorReady',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);

          // on ck editor ready
          String newFile = 'insertContent(`' + _composeBloc.htmlCode + '`)';
          _webViewController.evaluateJavascript(newFile);
        });
  }

  JavascriptChannel ckContentUpdate(BuildContext context) {
    return JavascriptChannel(
        name: 'CkContentUpdate',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
          _composeBloc.htmlCode = message.message;
          // print('~~~ CkContentUpdate: ${message.message}');
          // ck editor content
        });
  }

  JavascriptChannel customImageChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'CkImage',
        onMessageReceived: (JavascriptMessage message) async {
          _webViewController.evaluateJavascript(_composeBloc.htmlCode);
          if (message.message == 'select') {
            String test, newFile;
            test = "http://files.mesbro.com/icons/mesbro-logo.png";
            test = await _composeBloc.appendImage();
            newFile = "insertImage('" + test + "')"; // url goes here
            // print('~~~ newFile: $newFile');
            _webViewController.evaluateJavascript(newFile);
          }
        });
  }

  Widget _composeFinished(Map<String, dynamic> mapResponse) {
    if (mapResponse['code'] == 200) {
      _navigationActions.closeDialog();
      _navigationActions.previousScreenUpdate();
      _widgetsCollection.showToastMessage("${mapResponse['message']}");
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
}
