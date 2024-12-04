import 'dart:async';

import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/ratingDialog.dart';
import 'package:faulkner_footsteps/pages/map_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:faulkner_footsteps/list_item.dart';

class AdminListPage extends StatefulWidget {
  AdminListPage({super.key});

  ApplicationState app_state = ApplicationState();

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  void _incrementCounter() {
    setState(() {
      //HistSite newSite = HistSite(name: "Example piece 3", description: "This is an example piece for this presentation we are making. This is a description of the universe within our feeble mortal minds.",blurbs: [InfoText(title: "This is a tittle for this section of the thing", value: "This is a short description blurb.", date: "The dates can be any string for the sake of flexibility."), InfoText(title: "This is a very long section to show possibilities", value: "GibbirishGibbirishGibbirishGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirish")], images: []);
      //widget.app_state.addSite(newSite);
    });
  }

  void _update(Timer timer) {
    setState(() {});
  }

  // Future<void> showRatingDialog() async {
  //   await showDialog<double>(
  //     context: context,
  //     builder: (BuildContext context) => const RatingDialog(),
  //   );
  // }

  late Timer updateTimer;
  @override
  void initState() {
    super.initState();
    updateTimer = Timer.periodic(const Duration(milliseconds: 500), _update);
    setState(() {});
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) { // Index 1 for the "Map" tab so Index 2 -> for another...
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapDisplay(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    updateTimer.cancel();
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: widget.app_state.historicalSites.length,
            itemBuilder: (BuildContext context, int index) {
              HistSite site = widget.app_state.historicalSites[index];
              return ListItem(siteInfo: site, app_state: widget.app_state);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 196, 166),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 186, 130),
        elevation: 12.0, // Adds shadow effect
        shadowColor: const Color.fromARGB(135, 255, 255, 255), // Optional: customize shadow color
        title: Text(
          _selectedIndex == 0 ? "Display page for hist sites" : "Map Display",
          style: GoogleFonts.ultra(
            textStyle: const TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
          ),
        ),
      ),

      body: _selectedIndex == 0 
          ? _buildHomeContent() 
          : const MapDisplay(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 218, 180, 130),
        selectedItemColor: const Color.fromARGB(255, 124, 54, 16),
        unselectedItemColor: const Color.fromARGB(255, 124, 54, 16),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}