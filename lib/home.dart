import 'package:creditcal/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var creditsleft = 0;
  var today = DateTime.now().day;
  var perdayleft = 0;
  var spenttoday = 0;
  var todayslimit = 0;
  var futurelimit = 0;
  var loading = true;

  final TextEditingController controller = TextEditingController();

  // Future<int> checkIfNewMonthStarted() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final now = DateTime.now();
  //   final currentMonth = now.month;
  //   final currentYear = now.year;

  //   // Get saved month and year
  //   final savedMonth = prefs.getInt('lastMonth') ?? currentMonth;
  //   final savedYear = prefs.getInt('lastYear') ?? currentYear;

  //   // Check if it's a new month
  //   if (savedMonth != currentMonth || savedYear != currentYear) {
  //     // Save the new month and year
  //     await prefs.setInt('lastMonth', currentMonth);
  //     await prefs.setInt('lastYear', currentYear);
  //     return 1;
  //     // You can trigger your logic here (e.g., reset counters)
  //   } else {
  //     return 0;
  //   }
  // }

  void getTodaysSpending() async {
    String formatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<Map<String, dynamic>> data = await DatabaseHelper().gettodaysSpendings(
      formatted,
    );
    if (data.isNotEmpty) {
      setState(() {
        for (int i = 0; i < data.length; i++) {
          int qty = data[i]["qty"];
          int credits = data[i]["credits"];
          spenttoday += qty * credits;
        }
      });
    } else {
      setState(() {
        spenttoday = 0;
      });
    }
  }

  void fetchdata() async {
    String formatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final data = await DatabaseHelper().getData();
    final day = DateTime.now().day;

    String formatted2 = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.parse(data[0]["resetdate"]));
    if (day == 1) {
      //check database if the credits left is reset.ie check whether the date is todays date.if today's date its already reset else rest it
      //for new users add current as date doesnt exist in db
      if (formatted2 != formatted) {
        await DatabaseHelper().updatecreditsleft(data[0]["totalcredits"]);
        await DatabaseHelper().updateresetdate(DateTime.now());
        final tc = data[0]["totalcredits"];
        var a = (daysInCurrentMonth() - today + 1);
        final creditlimit = (creditsleft / a).toInt();
        var a1 = (daysInCurrentMonth() - today);
        final flimit = (creditsleft / a1).toInt();
        await DatabaseHelper().updateLimit(creditlimit, DateTime.now());
        setState(() {
          creditsleft = tc;
          perdayleft = creditlimit;
          loading = false;
          todayslimit = creditlimit;
          futurelimit = flimit;
          getTodaysSpending();
        });
      } else {
        final limittoday = await DatabaseHelper().getLimit();
        // String formatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
        // String formatted2 = DateFormat(
        //   'yyyy-MM-dd',
        // ).format(DateTime.parse(limittoday[0]["date"]));
        setState(() {
          creditsleft = data[0]["creditsleft"];
          var a = (daysInCurrentMonth() - today + 1);
          perdayleft = (creditsleft / a).toInt();
          var a1 = (daysInCurrentMonth() - today);
          final flimit = (creditsleft / a1).toInt();
          futurelimit = flimit;
          todayslimit = limittoday[0]["credlimit"];
          loading = false;
          getTodaysSpending();
        });
      }
    } else {
      final limittoday = await DatabaseHelper().getLimit();
      String formatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formatted2 = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(limittoday[0]["date"]));
      if (formatted2 != formatted) {
        final cl = data[0]["creditsleft"];
        var a = (daysInCurrentMonth() - today + 1);
        final creditlimit = (cl / a).toInt();
        await DatabaseHelper().updateLimit(creditlimit, DateTime.now());
        setState(() {
          creditsleft = data[0]["creditsleft"];
          var a = (daysInCurrentMonth() - today + 1);
          perdayleft = (creditsleft / a).toInt();
          todayslimit = limittoday[0]["credlimit"];
          var a1 = (daysInCurrentMonth() - today);
          final flimit = (creditsleft / a1).toInt();
          futurelimit = flimit;

          loading = false;
          getTodaysSpending();
        });
      } else {
        final limittoday = await DatabaseHelper().getLimit();

        setState(() {
          creditsleft = data[0]["creditsleft"];
          var a = (daysInCurrentMonth() - today + 1);
          perdayleft = (creditsleft / a).toInt();
          var a1 = (daysInCurrentMonth() - today);
          final flimit = (creditsleft / a1).toInt();
          futurelimit = flimit;
          todayslimit = limittoday[0]["credlimit"];
          loading = false;
          getTodaysSpending();
        });
      }
    }
    // final limitdata = await DatabaseHelper().getLimit(formatted);
    // if (data[0]["newmonth"] == 1) {
    //   await DatabaseHelper().updatecredits(data[0]["totalcredits"]);
    //   setState(() {
    //     creditsleft = 7000;
    //     var a = (daysInCurrentMonth() - today + 1);
    //     perdayleft = (creditsleft / a).toInt();
    //     loading = false;
    //     todayslimit = 0;
    //     getTodaysSpending();
    //   });
    // } else {
    //   setState(() {
    //     creditsleft = data[0]["creditsleft"];
    //     var a = (daysInCurrentMonth() - today + 1);
    //     perdayleft = (creditsleft / a).toInt();
    //     loading = false;
    //     getTodaysSpending();
    //   });
    // }
  }

  // void load() async {
  //   final data = await DatabaseHelper().getData();
  //   setState(() {
  //     creditsleft = data[0]["creditsleft"];
  //     var a = (daysInCurrentMonth() - today + 1);
  //     perdayleft = (creditsleft / a).toInt();
  //     loading = false;
  //     getTodaysSpending();
  //   });
  //   final player = AudioPlayer();
  //   final prefs = await SharedPreferences.getInstance();
  //   final volume = prefs.getInt('volume') ?? 1;
  //   if (volume == 1) {
  //     await player.setSource(AssetSource("burp.mp3"));
  //     await player.resume();
  //   }
  // }

  int daysInCurrentMonth() {
    DateTime now = DateTime.now();
    DateTime beginningNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    DateTime lastDayOfMonth = beginningNextMonth.subtract(Duration(days: 1));
    return lastDayOfMonth.day;
  }

  // void add(value) async {
  //   await DatabaseHelper().buy((creditsleft - value).toInt());
  //   load();
  // }

  // void sub(value) async {
  //   await DatabaseHelper().buy((creditsleft + value).toInt());
  //   load();
  // }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Credits Left",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 25,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹$creditsleft",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 75,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Container(
              //       height: 200,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       child: Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               "Per Day",
              //               style: GoogleFonts.poppins(
              //                 color: Colors.black,
              //                 fontSize: 20,
              //                 // fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Text(
              //               "₹$perdayleft",
              //               style: GoogleFonts.poppins(
              //                 color: Colors.black,
              //                 fontSize: 40,
              //                 fontWeight: FontWeight.w800,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Today's Limit",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹$todayslimit",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Spent Today",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹$spenttoday",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "From Tomorrow Onwards",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹$futurelimit",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
