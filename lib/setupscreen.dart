import 'package:creditcal/databasehelper.dart';
import 'package:creditcal/mainactivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class SetupScreen extends StatefulWidget {
  SetupScreen({super.key});
  @override
  State<SetupScreen> createState() {
    return _setupScreenState();
  }
}

class _setupScreenState extends State<SetupScreen> {
  TextEditingController tccontroller = TextEditingController();
  TextEditingController clcontroller = TextEditingController();
  void newData() async {
    int cl = int.parse(clcontroller.text);
    int tc = int.parse(tccontroller.text);
    if (cl > tc || cl < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Credits left should be greater than 0 and lesser than total credits",
          ),
          duration: Durations.extralong4,
        ),
      );
    } else if (tc < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Total credits should be a positive integer"),
          duration: Durations.extralong4,
        ),
      );
    } else {
      var today = DateTime.now().day;
      var a = (daysInCurrentMonth() - today + 1);
      int limit = (int.parse(clcontroller.text) / a).toInt();
      await DatabaseHelper().newdata(
        int.parse(tccontroller.text),
        int.parse(clcontroller.text),
        DateTime.now(),
      );
      await DatabaseHelper().newLimit(DateTime.now(), limit);
      Navigator.of(context).pop();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => Mainactivity()));
    }
  }

  int daysInCurrentMonth() {
    DateTime now = DateTime.now();
    DateTime beginningNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    DateTime lastDayOfMonth = beginningNextMonth.subtract(Duration(days: 1));
    return lastDayOfMonth.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please fill in the details below to proceed.",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Monthly Credit limit",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: tccontroller,
                decoration: InputDecoration(
                  hint: Text("Enter Value"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 5),
              Text(
                "Credits left in your Wallet",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: clcontroller,
                decoration: InputDecoration(
                  hint: Text("Enter Value"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    if (clcontroller.text != "" && tccontroller.text != "") {
                      newData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please fill in the details above to proceed",
                          ),
                          duration: Durations.extralong4,
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    "Proceed",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
