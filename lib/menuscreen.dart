import 'package:creditcal/components/menuitem.dart';
import 'package:creditcal/databasehelper.dart';
import 'package:creditcal/menuitemm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  var loading = true;
  var _searchData = "";
  List<MenuItemm> filteredList = [];
  List<MenuItemm> items = [];
  void fetchItems() async {
    final data = await DatabaseHelper().getItems();
    setState(() {
      items = data
          .map(
            (e) => MenuItemm(name: e["name"], price: e["credits"], id: e["ID"]),
          )
          .toList();
      filteredList = items.reversed.toList();
      loading = false;
    });
  }

  void addItemToDB(name, price) async {
    await DatabaseHelper().newItem(name, price);
    fetchItems();
  }

  void editItem(name, price, id) async {
    await DatabaseHelper().updateItem(name, int.parse(price), id);
    fetchItems();
  }

  void deleteItem(id) async {
    await DatabaseHelper().deleteItem(id);
  }

  Future<bool> deleteItemConfirmation() async {
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
      ),
    );
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

  void openEditDialog(name, credits, id) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    nameController.text = name;
    priceController.text = credits;
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
                            editItem(
                              nameController.text,
                              priceController.text,
                              id,
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {}
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

  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      SizedBox(height: 20),
                      filteredList.isEmpty
                          ? Center(child: Text("No products"))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Dismissible(
                                      onDismissed: (direction) =>
                                          deleteItem(filteredList[index].id),
                                      confirmDismiss: (direction) =>
                                          deleteItemConfirmation(),
                                      direction: DismissDirection.endToStart,
                                      key: Key(
                                        filteredList[index].id.toString(),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(.0),
                                        child: MenuItem(
                                          name: filteredList[index].name,
                                          price: filteredList[index].price,

                                          editpressed: () {
                                            openEditDialog(
                                              filteredList[index].name,
                                              filteredList[index].price
                                                  .toString(),
                                              filteredList[index].id,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
