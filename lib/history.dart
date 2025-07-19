import 'package:creditcal/components/historyitem.dart';
import 'package:creditcal/databasehelper.dart';
import 'package:creditcal/historyItemmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class History extends StatefulWidget {
  History({super.key});
  @override
  State<History> createState() {
    // TODO: implement createState
    return _historyState();
  }
}

class _historyState extends State<History> {
  var _Loading = true;
  List<Historyitemmodel> items = [];
  void fetchData() async {
    final List<Map<String, dynamic>> hisitems = await DatabaseHelper()
        .getHistory();
    setState(() {
      items = hisitems
          .map(
            (e) => Historyitemmodel(
              name: e["name"],
              price: e["credits"],
              qty: e["qty"],
              id: e["ID"],
              date: e["date"],
            ),
          )
          .toList()
          .reversed
          .toList();
      _Loading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: _Loading
          ? Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? Center(
              child: Text(
                "No Items in History....",
                style: GoogleFonts.roboto(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Historyitem(
                name: items[index].name,
                date: items[index].date,
                qty: items[index].qty,
                price: items[index].price,
              ),
            ),
    );
  }
}
