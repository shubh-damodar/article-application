import 'package:articles/screens/article/View_Article/view_article_page.dart';
import 'package:articles/screens/article/compose_article_page.dart';
import 'package:articles/screens/article/explore_page.dart';
import 'package:articles/screens/article/favourite_page.dart';
import 'package:articles/screens/article/my_article_edit.dart';
import 'package:articles/screens/article/read_later_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:articles/screens/idm/forgot_password_page.dart';
import 'package:articles/screens/home_page.dart';
import 'package:articles/screens/idm/login_page.dart';
import 'package:articles/screens/profile_screens/edit_profile_screens/profile_page.dart';
import 'package:articles/screens/idm/register_page.dart';
import 'package:articles/utils/network_connectivity.dart';
import 'package:articles/utils/shared_pref_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';
import 'network/user_connect.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

void main() {
  Stetho.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPrefManager.getSharedPref().then((SharedPreferences sharedPreferences) {
    SharedPrefManager.getCurrentUser().then((User user) {
      SharedPrefManager.getAllUsers();
      if (user != null) {
        Connect.currentUser = user;
      }
      runApp(MyApp());
    });
  });
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorStateGlobalKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NetworkConnectivity(
        widget: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mesbro Articles',
            theme: ThemeData(
                accentColor: Colors.deepOrange,
                primarySwatch: Colors.deepOrange,
                fontFamily: 'Poppins'),
            home: Connect.currentUser == null
                ? LoginPage(previousScreen: '')
                : ExploreArticlePage(),
            routes: <String, WidgetBuilder>{
          '/login_page': (BuildContext context) =>
              LoginPage(previousScreen: ''),
          '/register_page': (BuildContext context) => RegisterPage(),
          '/home_page': (BuildContext context) => HomePage(),
          '/forgot_password_page': (BuildContext context) =>
              ForgotPasswordPage(),
          '/profile_page': (BuildContext context) => ProfilePage(),
          '/explore_page': (BuildContext context) => ExploreArticlePage(),
          '/home_page': (BuildContext context) => HomePage(),
          '/composeArticle': (BuildContext context) => ComposeArticlePage(),
          '/favourite_page': (BuildContext context) => FavouriteArticlePage(),
          '/my_article_edit': (BuildContext context) => EditArticlePage(),
          '/read_later_page': (BuildContext context) => ReadLaterPage(),
          '/view_article_page': (BuildContext context) => ViewArticle(),
        }));
  }
}
