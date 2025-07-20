import 'package:creditcal/components/orderitem.dart';
import 'package:creditcal/databasehelper.dart';
import 'package:creditcal/item.dart';
import 'package:creditcal/ordereditem.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({super.key});
  @override
  State<OrderScreen> createState() {
    return _orderScreenState();
  }
}

class _orderScreenState extends State<OrderScreen> {
  List<Item> items = [];
  List<Item> filteredList = [];
  List<OrderedItem> orderList = [];
  Map<int, int> quantities = {};
  var Loading = true;
  int total_price = 0;
  String _searchData = "";

  void confirmOrder() async {
    await DatabaseHelper().order(orderList, total_price);
    setState(() {
      Loading = true;
      total_price = 0;
      orderList = [];
      filteredList = [];
      items = [];
      quantities = {};
      fetchData();
    });
  }

  void addItemtocart(Item item) {
    quantities[item.id] = (quantities[item.id] ?? 0) + 1;
    List<OrderedItem> nitems = orderList
        .where((element) => element.id == item.id)
        .toList();
    if (nitems.isEmpty) {
      orderList.add(
        OrderedItem(name: item.name, price: item.price, qty: 1, id: item.id),
      );
    } else {
      orderList.firstWhere((element) => element.id == item.id).qty += 1;
    }
  }

  void removeItemfromcart(Item item) {
    List<OrderedItem> nitems = orderList
        .where((element) => element.id == item.id)
        .toList();
    if (nitems.isNotEmpty) {
      if (orderList.firstWhere((element) => element.id == item.id).qty == 1) {
        orderList.removeWhere((element) => element.id == item.id);
        quantities.remove(item.id);
      } else {
        orderList.firstWhere((element) => element.id == item.id).qty -= 1;
        quantities[item.id] = quantities[item.id]! - 1;
      }
    }
  }

  void setItems() {
    if (_searchData.trim() == '') {
      filteredList = items;
    } else {
      filteredList = items
          .where(
            (item) => item.name.toString().toLowerCase().contains(
              _searchData.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  void addItemToDB(name, price) async {
    await DatabaseHelper().newItem(name, price);
    fetchData();
  }

  void openAddDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
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
                "Name",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hint: Text("eg: Masala Dosa"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Price",
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
                    decimal: false,
                    signed: false,
                  ),
                  controller: priceController,
                  decoration: InputDecoration(
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
                        try {
                          if (nameController.text != "") {
                            addItemToDB(
                              nameController.text,
                              int.parse(priceController.text),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {}
                      },
                      label: Text(
                        "Add",
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
                        // sub(int.parse(controller.text));
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
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    List<Map<String, dynamic>> nitems = await DatabaseHelper().getItems();
    List<Item> nnitems = nitems
        .map(
          (item) =>
              Item(name: item["name"], price: item["credits"], id: item["ID"]),
        )
        .toList();
    setState(() {
      items = nnitems;
      filteredList = nnitems.reversed.toList();
      Loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Loading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      openAddDialog();
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
                      "Add New Item",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: SearchBar(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    shadowColor: WidgetStatePropertyAll(Colors.white),
                    hintText: "Search",
                    onChanged: (value) {
                      _searchData = value;
                      setState(() {
                        setItems();
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            "No Saved Items...",
                            style: GoogleFonts.roboto(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) => OrderItem(
                            key: ValueKey(filteredList[index].id),
                            name: filteredList[index].name,
                            price: filteredList[index].price,
                            addtocart: (int qty) {
                              setState(() {
                                total_price =
                                    total_price +
                                    (filteredList[index].price * qty);
                                if (qty == 1) {
                                  addItemtocart(filteredList[index]);
                                } else {
                                  removeItemfromcart(filteredList[index]);
                                }
                              });
                            },
                            qty: quantities[filteredList[index].id] ?? 0,
                          ),
                        ),
                ),
                total_price > 0
                    ? SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            confirmOrder();
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
                            "Place Order (Total: ₹$total_price)",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          );
  }
}
