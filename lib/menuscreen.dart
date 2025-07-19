import 'package:creditcal/components/menuitem.dart';
import 'package:creditcal/databasehelper.dart';
import 'package:creditcal/menuitemm.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({super.key});
  @override
  State<MenuScreen> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  var loading = true;
  var _searchData = "";
  List<MenuItemm> items = [];
  void fetchItems() async {
    final data = await DatabaseHelper().getItems();
    setState(() {
      items = data
          .map(
            (e) => MenuItemm(name: e["name"], price: e["credits"], id: e["ID"]),
          )
          .toList();
      loading = false;
    });
  }

  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: SearchBar(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    shadowColor: WidgetStatePropertyAll(Colors.white),
                    hintText: "Search",
                    onChanged: (value) {
                      _searchData = value;
                      // setState(() {
                      //   setItems();
                      // });
                    },
                  ),
                ),
                SizedBox(height: 20),
                items.isEmpty
                    ? Center(child: Text("No products"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) => MenuItem(
                            name: items[index].name,
                            price: items[index].price,
                            deletepressed: () {},
                            editpressed: () {},
                          ),
                        ),
                      ),
              ],
            ),
          );
  }
}
