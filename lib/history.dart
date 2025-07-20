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

  void deleteHistoryItem(id, credits) async {
    final data = await DatabaseHelper().getData();
    await DatabaseHelper().deleteHistoryItem(id);
    await DatabaseHelper().updatecreditsleft(data[0]["creditsleft"] + credits);
  }

  Future<bool> deleteHistoryItemConfirmation() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Delete"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel"),
          ),
        ],
        title: Text("Delete item from history"),
        content: Text(
          "The item will be deleted and the credits will be added to creditsleft",
        ),
      ),
    );
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _Loading
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
        : Column(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.lightGreen[100]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline_rounded),
                    SizedBox(width: 8),
                    Text(
                      "Swipe an item to the left to delete",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => deleteHistoryItem(
                          items[index].id,
                          items[index].price * items[index].qty,
                        ),
                        confirmDismiss: (direction) {
                          return deleteHistoryItemConfirmation();
                        },
                        key: Key(items[index].id.toString()),
                        child: Historyitem(
                          name: items[index].name,
                          date: items[index].date,
                          qty: items[index].qty,
                          price: items[index].price,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
