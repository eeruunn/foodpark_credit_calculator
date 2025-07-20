import 'package:creditcal/history.dart';
import 'package:creditcal/home.dart';
import 'package:creditcal/menuscreen.dart';
import 'package:creditcal/order.dart';
import 'package:creditcal/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainactivity extends StatefulWidget {
  const Mainactivity({super.key});
  @override
  State<Mainactivity> createState() {
    return MainactivityState();
  }
}

class MainactivityState extends State<Mainactivity> {
  final screens = [
    MyHomePage(),
    OrderScreen(),
    History(),
    MenuScreen(),
    Settings(),
  ];
  var currentIndex = 0;
  var volumecon = 1;
  var firsttime = true;
  var loading = true;
  static const titles = ["Dashboard", "Order", "History", "Menu", "Settings"];

  @override
  void initState() {
    super.initState();
    getvol();
  }

  void getvol() async {
    final prefs = await SharedPreferences.getInstance();
    final volume = prefs.getInt('volume') ?? 1;
    setState(() {
      volumecon = volume;
    });
  }

  void volume() async {
    final prefs = await SharedPreferences.getInstance();
    final volume = prefs.getInt('volume') ?? 1;
    if (volume == 1) {
      await prefs.setInt('volume', 0);
    } else {
      await prefs.setInt('volume', 1);
    }
    getvol();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [],
        backgroundColor: Colors.lightGreen,
        title: currentIndex == 0
            ? Image.asset("assets/logo.png", height: 40)
            : Text(
                titles[currentIndex],
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            activeIcon: Icon(Icons.add),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            activeIcon: Icon(Icons.history_rounded),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_rounded),
            activeIcon: Icon(Icons.restaurant_menu_rounded),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
