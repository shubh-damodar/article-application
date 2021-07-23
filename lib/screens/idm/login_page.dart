import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:articles/bloc_patterns/idm_bloc_patterns/login_bloc.dart';
import 'package:articles/models/user.dart';
import 'package:articles/network/user_connect.dart';
import 'package:articles/screens/idm/register_page.dart';
import 'package:articles/utils/navigation_actions.dart';
import 'package:articles/utils/shared_pref_manager.dart';
import 'package:articles/utils/widgets_collection.dart';

import 'forgot_password_page.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  final String previousScreen;

  LoginPage({this.previousScreen});

  _LoginPageState createState() =>
      _LoginPageState(previousScreen: previousScreen);
}

class _LoginPageState extends State<LoginPage> {
  final String previousScreen;

  _LoginPageState({this.previousScreen});

  final LoginBloc _loginBloc = LoginBloc();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();
  TextEditingController _usernameTextEditingController =
          TextEditingController(),
      _passwordTextEditingController = TextEditingController();
  bool _isPasswordVisible = true;

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
  }

  void dispose() {
    super.dispose();
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _loginBloc.dispose();
  }

  Future<bool> _onWillPop() async {
    if (previousScreen == 'explore_page') {
      return true;
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: Form(
              autovalidate: false,
              key: _loginformKey,
              child: Center(
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(60.0),
                  ),
                  Image(
                    image: AssetImage("assets/images/mesbro.png"),
                    width: 150.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  ListTile(
                    title: Text(
                      "Search, Share and Save Anything,",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: Colors.black26),
                    ),
                    subtitle: Text(
                      "Communicate Freely and Grow Exponentially",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: Colors.black26),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: TextFormField(
                      controller: _usernameTextEditingController,
                      validator: (String value) {
                        String _usernamePattern = "^[A-Za-z0-9._]*\$";
                        RegExp _regExp = RegExp(_usernamePattern);
                        if (value.length < 5 || value.length > 20) {
                          return 'Username should have characters between 5 and 20';
                        } else if (!_regExp.hasMatch(value)) {
                          return 'Username can have alphabets, numbers, . and _ only';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Username',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: TextFormField(
                      controller: _passwordTextEditingController,
                      validator: (String value) {
                        if (value.length < 8 || value.length > 32) {
                          return 'Password should have characters between 8 and 32';
                        }
                        return null;
                      },
                      obscureText: _isPasswordVisible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye,
                                color: _isPasswordVisible
                                    ? Colors.grey
                                    : Colors.deepOrange),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            }),
                        labelText: 'Password',
                        hintText: 'Password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  ButtonTheme(
                      height: 40.0,
                      minWidth: 350.0,
                      child: RaisedButton(
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onPressed: () {
                            if (_loginformKey.currentState.validate()) {
                              _widgetsCollection.showMessageDialog();
                              _loginBloc.checkLogin(
                                  _usernameTextEditingController.text,
                                  _passwordTextEditingController.text);
                            }
                          })),
                  StreamBuilder(
                      stream: _loginBloc.loginStream,
                      builder:
                          (BuildContext context, AsyncSnapshot asyncSnapshot) {
                        return asyncSnapshot.data == null
                            ? Container(
                                width: 0.0,
                                height: 0.0,
                              )
                            : _loginFinished(asyncSnapshot.data);
                      }),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 18.0),
                      ),
                      GestureDetector(
                        child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text('Forgot Password?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.0,
                                    color: Colors.black38))),
                        onTap: () {
                          _navigationActions
                              .navigateToScreenWidget(ForgotPasswordPage(
                            previousScreen: widget.previousScreen,
                          ));
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'New To Mesbro? ',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: 'Join Now',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _navigationActions
                                    .navigateToScreenWidget(RegisterPage(
                                  previousScreen: widget.previousScreen,
                                ));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }

  Widget _loginFinished(Map<String, dynamic> mapResponse) {
    Future.delayed(Duration.zero, () {
      _navigationActions.closeDialog();
      _loginBloc.loginStreamSink.add(null);

      if (mapResponse['code'] == 200) {
        Map<String, dynamic> userMap = mapResponse['content']['userDetails'];
        if (SharedPrefManager.usersList.length > 0 &&
            widget.previousScreen == 'explore_page') {
          bool _isAlreadyLoggedIn = false;
          for (User user in SharedPrefManager.usersList) {
            if (user.userId == userMap['id']) {
              _widgetsCollection.showToastMessage('User already logged In');
              _isAlreadyLoggedIn = true;
            }
          }

          if (!_isAlreadyLoggedIn) {
            SharedPrefManager.setCurrentUser(User(
              userId: userMap['id'].toString(),
              username: userMap['username'].toString(),
              name:
                  '${userMap['firstName'].toString()} ${userMap['lastName'].toString()}',
              logo: userMap['profileImage'].toString(),
              au: mapResponse['content']['au'].toString(),
              token: mapResponse['content']['token'].toString(),
              cc: userMap['countryCode'].toString(),
              bannerImage: userMap['bannerImage'].toString(),
            )).then((value) {
              _navigationActions.navigateToScreenNameRoot('explore_page');
            });
          }
        } else {
          SharedPrefManager.setCurrentUser(User(
            userId: userMap['id'].toString(),
            username: userMap['username'].toString(),
            name:
                '${userMap['firstName'].toString()} ${userMap['lastName'].toString()}',
            logo: userMap['profileImage'].toString(),
            au: mapResponse['content']['au'].toString(),
            token: mapResponse['content']['token'].toString(),
            cc: userMap['countryCode'].toString(),
            bannerImage: userMap['bannerImage'].toString(),
          )).then((value) {
            _navigationActions.navigateToScreenNameRoot('explore_page');
          });
        }
      } else {
        _widgetsCollection.showToastMessage(mapResponse['content']['message']);
      }
    });
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }
}
