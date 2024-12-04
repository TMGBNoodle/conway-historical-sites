import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'info_text.dart';
import 'hist_site.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _siteSubscription;

  List<HistSite> _historicalSites = [];
  List<HistSite> get historicalSites => _historicalSites;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (true) {
        //user == null, changed for debugging
        _loggedIn = true;
        _siteSubscription = FirebaseFirestore.instance
            .collection('sites')
            .snapshots()
            .listen((snapshot) {
          _historicalSites = [];
          for (final document in snapshot.docs) {
            var blurbCont = document.data()["blurbs"];
            List<String> blurbStrings = blurbCont.split("{ListDiv}");
            List<InfoText> newBlurbs = [];
            for (var blurb in blurbStrings) {
              List<String> values = blurb.split("{IFDIV}");
              newBlurbs.add(InfoText(
                  title: values[0], value: values[1], date: values[2]));
            }
            _historicalSites.add(HistSite(
              name: document.data()["name"] as String,
              description: document.data()["description"] as String,
              blurbs: newBlurbs,
              images: [],
              //added ratings
              avgRating: document.data()["avgRating"] != null
                  ? (document.data()["avgRating"] as num).toDouble()
                  : 0.0,
              ratingAmount: document.data()["ratingCount"] != null
                  ? document.data()["ratingCount"] as int
                  : 0,
            ));
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _historicalSites = [];
        _siteSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  void addSite(HistSite newSite) {
    //using the variable to contain information for sake of readability. May refactor later
    // if(!_loggedIn) { UNCOMMENT THIS LATER. COMMENTED OUT FOR TESTING PURPOSES
    //   throw Exception("Must be logged in");
    // }

    var data = {
      "name": newSite.name,
      "description": newSite.description,
      "blurbs": newSite.listifyBlurbs(),
      "images": "testValue",
      //added ratings here
      "avgRating": newSite.avgRating,
      "ratingAmount": newSite.ratingAmount,
    };

    print('Adding site with $data');
    FirebaseFirestore.instance.collection("sites").doc(newSite.name).set(data);
    FirebaseFirestore.instance.collection("sites").doc(newSite.name).collection("ratings");
  }

  //update/store rating in firebase
  void updateSiteRating(String siteName, double newRating) async {
    final site = _historicalSites.firstWhere((s) => s.name == siteName);
    if (site != null) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      double totalRating = 0;
      int ratingcount = 0;
      FirebaseFirestore.instance.collection("sites").doc(siteName).collection("ratings").doc(FirebaseAuth.instance.currentUser!.uid).set({"rating" : newRating});
      await FirebaseFirestore.instance.collection("sites").doc(siteName).collection("ratings").get().then(
        (snapshot) {
          for(final doc in snapshot.docs) {
            totalRating += doc.data()["rating"];
            ratingcount += 1;
            print(totalRating);
            print(ratingcount);
          }
      });
      double finalRating = totalRating/ratingcount;
      print("This is a final rating $finalRating");
      site.avgRating = finalRating;
      site.ratingAmount = ratingcount;
      FirebaseFirestore.instance.collection("sites").doc(siteName).update({"avgRating" : finalRating, "ratingCount" : ratingcount});
      notifyListeners();
    }
  }
}
