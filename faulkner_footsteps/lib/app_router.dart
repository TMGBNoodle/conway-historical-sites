import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/pages/list_page.dart';
import 'package:faulkner_footsteps/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< Updated upstream
import 'package:faulkner_footsteps/pages/hist_site_page.dart';
=======
import 'package:faulkner_footsteps/pages/start_page.dart';

>>>>>>> Stashed changes

class AppRouter {
  // shorthand for each page
  static const String startPage = '/';
  static const String loginPage = '/login';
  static const String list = '/list';
  static const String hsitePage = '/hist';

  //static HistSite newSite = HistSite(name: "TEST", blurbs: [InfoText(title: "INTRO", value: "HELLO WORLD")], images: [AssetImage('assets/images/AutobotLogo.png')]);

  // cases for the router, what should happen when moving to this page
  // removed static from infront of Route for HistSitePage
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic> info;
    if (settings.arguments != null) {
      info = settings.arguments as Map<String, dynamic>;
    } else {
      info = {
        "info": HistSite(
            name: "Argument Error",
            description: "Please restart the app",
            blurbs: [
              InfoText(
                  title: "there was an error",
                  value:
                      "An error has appeared when trying to navigate to a page for this historical site. Please restart the app.")
            ],
            images: [],
            //added ratings here
            avgRating: 0.0,
            ratingAmount: 0)
      };
    }
    switch (settings.name) {
      case startPage:
        return MaterialPageRoute(builder: (_) => const StartPage());
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case list:
        return MaterialPageRoute(builder: (_) => ListPage());
      case hsitePage:
        return MaterialPageRoute(
            builder: (_) => HistSitePage(app_state: info["app_state"],histSite: info["info"]));
      default:
        return _errorRoute();
    }
  }

  // error catch, displays errors for the user
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }

  // navigation fo pages, what causes the actual moving between pages
  static Future<void> navigateTo(BuildContext context, String routeName,
      {Map<String, dynamic>? arguments}) async {
    if (FirebaseAuth.instance.currentUser == null && routeName != loginPage) {
      await Navigator.pushReplacementNamed(context, loginPage);
    } else {
      await Navigator.pushNamed(context, routeName, arguments: arguments);
    }
  }

  void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
