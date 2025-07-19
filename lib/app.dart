import 'package:creditcal/databasehelper.dart';
import 'package:creditcal/mainactivity.dart';
import 'package:creditcal/setupscreen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var firsttime = true;
  var loading = true;

  void checkfirsttime() async {
    final result = await DatabaseHelper().getData();
    if (result.isNotEmpty) {
      setState(() {
        firsttime = false;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkfirsttime();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Scaffold(body: Center(child: CircularProgressIndicator()));
    if (!loading) {
      if (firsttime == false) {
        widget = Mainactivity();
      } else {
        widget = SetupScreen();
      }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Credit Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: widget,
    );
  }
}
