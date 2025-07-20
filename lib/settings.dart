import 'package:creditcal/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() {
    return _settingsState();
  }
}

class _settingsState extends State<Settings> {
  var _Loading = true;
  int totalcreditspermonth = 0;
  int creditsleft = 0;
  TextEditingController tccontroller = TextEditingController();
  TextEditingController clcontroller = TextEditingController();
  void updateCredits(credits) async {
    await DatabaseHelper().updatecredits(int.parse(credits));
    setState(() {
      _Loading = true;
    });
    fetchData();
  }

  void openLink(link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void updateCreditsleft(credits) async {
    await DatabaseHelper().updatecreditsleft(credits);
    setState(() {
      _Loading = true;
    });
    fetchData();
  }

  void fetchData() async {
    List<Map<String, dynamic>> data = await DatabaseHelper().getData();
    setState(() {
      totalcreditspermonth = data[0]["totalcredits"];
      creditsleft = data[0]["creditsleft"];
      _Loading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void openCreditChangemodel() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30),
              Text(
                "Total credits per month",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  controller: tccontroller,
                  decoration: InputDecoration(
                    hint: Text("Enter Value"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        updateCredits(tccontroller.text.toString());
                        Navigator.pop(context);
                      },
                      label: Text(
                        "Save",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: Text(
                        "Cancel",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openCreditleftChangemodel() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30),
              Text(
                "Credits left",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  controller: clcontroller,
                  decoration: InputDecoration(
                    hint: Text("Enter Value"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        try {
                          int value = int.parse(clcontroller.text);
                          if (value <= totalcreditspermonth && value >= 0) {
                            updateCreditsleft(value);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Value should be greater than zero and less than credits per month",
                                ),
                                duration: Durations.extralong4,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Value should be greater than zero and less than credits per month",
                              ),
                              duration: Durations.extralong4,
                            ),
                          );
                        }
                      },
                      label: Text(
                        "Save",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: Text(
                        "Cancel",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: _Loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 10),
                            child: Text(
                              "Total credits per month",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "$totalcreditspermonth",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: IconButton(
                                  onPressed: () {
                                    openCreditChangemodel();
                                  },
                                  icon: Icon(Icons.edit, color: Colors.green),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 10),
                            child: Text(
                              "Credits Left",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "$creditsleft",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: IconButton(
                                  onPressed: () {
                                    openCreditleftChangemodel();
                                  },
                                  icon: Icon(Icons.edit, color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              openLink(
                                "https://www.linkedin.com/in/arun-aravindan/",
                              );
                            },
                            child: Image.asset(
                              'assets/linkedin.png',
                              height: 30,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              openLink("https://www.instagram.com/eeruunn");
                            },
                            child: Image.asset(
                              'assets/instagram.png',
                              height: 30,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              openLink("https://github.com/eeruunn");
                            },
                            child: Image.asset('assets/github.png', height: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
