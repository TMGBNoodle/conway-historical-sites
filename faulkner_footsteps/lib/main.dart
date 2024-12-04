import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/dialogs/rating_Dialog.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/pages/hist_site_page.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:faulkner_footsteps/widgets.dart';
import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
// IMPORT RELATED TO MAP
// import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  // RELATED WITH MAP
  // // Require Hybrid Composition mode on Android.
  // final GoogleMapsFlutterPlatform mapsImplementation =
  //     GoogleMapsFlutterPlatform.instance;
  // if (mapsImplementation is GoogleMapsFlutterAndroid) {
  //   // Force Hybrid Composition mode.
  //   mapsImplementation.useAndroidViewSurface = true;
  // }
  // // ···

  runApp(
    ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Test for ratingLeaderBoard
  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historical Sites Leaderboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 119, 52, 16)),
        useMaterial3: true,
      ),
      home: RatingLeaderBoard(topHistSites: _createTempData()),
    );
  }

  //temp testing historical sites data
  List<HistSite> _createTempData() {
    return [
      HistSite(
        name: 'Historical Museum',
        blurbs: [InfoText(title: 'Location', value: 'Museum, Conway')],
        images: [AssetImage('museum image')],
      ),
      HistSite(
        name: 'Memorial',
        blurbs: [InfoText(title: 'Location', value: 'Memorial, Conway')],
        images: [AssetImage('memorial image')],
      ),
      HistSite(
        name: 'Historical Marker',
        blurbs: [InfoText(title: 'Location', value: 'Marker, Conway')],
        images: [AssetImage('marker image')],
      ),
      HistSite(
        name: 'Cemetary',
        blurbs: [InfoText(title: 'Location', value: 'Cemetary, Conway')],
        images: [AssetImage('cemetary image')],
      ),
      HistSite(
        name: 'Church',
        blurbs: [InfoText(title: 'Location', value: 'Church, Conway')],
        images: [AssetImage('church image')],
      ),
    ];
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faulkner Footsteps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRouter.startPage,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApplicationState app_state = ApplicationState();
  List<HistSite> historical_sites = [];
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      FirebaseFirestore.instance
          .collection('rooms')
          .doc('mainroom')
          .collection('players');
      HistSite newSite = HistSite(
        name: "The Big Church",
        description: "This is a large church",
        blurbs: [
          InfoText(
              title: "Historical Significance",
              value:
                  "The big church is a large church with a long history of doing stuff and things beyond the current eternity of existence.",
              date: "10/2/34"),
          InfoText(
              title: "Secondary Elist",
              value:
                  "This does not have a date but we still exist beyond the current state of human understanding and everything is something to another ellos")
        ],
        images: [],
        //added ratings here
        avgRating: 0.0,
        ratingAmount: 0,
      );
      app_state.addSite(newSite);
      print(historical_sites);
    });
  }

  //launches Rating Dialog
  Future<void> showRatingDialog(ApplicationState appState, String newSiteName) async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) => RatingDialog(app_state: appState, site_name: newSiteName),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample HistSite object
    HistSite sampleSite = HistSite(
      name: "Sample Site",
      description: "A simple same site for debugging.",
      blurbs: [
        InfoText(
            title: "Introduction",
            value: "This is a sample historical site.",
            date: "01/01/2024"),
        InfoText(
            title: "Significance",
            value: "It played a major role in local history."),
      ],
      images: [
        /*
        AssetImage('assets/images/AutobotLogo.png'),
        AssetImage('assets/images/AutobotLogo2.png'),
        AssetImage('assets/images/AutobotLogo.png'),
        */
      ], // Add images if available
      avgRating: 0.0,
      ratingAmount: 0,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to HistSitePage with sampleSite
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistSitePage(app_state: app_state, histSite: sampleSite),
                  ),
                );
              },
              child: const Text("View Sample Site"),
            ),
            const SizedBox(height: 20),
            // Button for launching rating dialog
            ElevatedButton(
              onPressed: () {
              },
              child: const Text("Rate this spot"),
            ),
            SizedBox(
                height: 500,
                child: ListView.builder(
                    itemCount: app_state.historicalSites.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("${app_state.historicalSites.length} eldritch");
                      HistSite site = app_state.historicalSites[index];
                      return TextBlurb(
                        site.name,
                        site.blurbs.toString(),
                        "",
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
