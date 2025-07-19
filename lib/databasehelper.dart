import 'package:creditcal/ordereditem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final int _version = 1;
  final String databaseName = "app.db";

  Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE data(ID INTEGER PRIMARY KEY AUTOINCREMENT,totalcredits INTEGER,creditsleft INTEGER,creditslefttoday INTEGER,resetdate DATETIME)",
        );
        await db.execute(
          "CREATE TABLE orderdata(ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,creditsleft INTEGER,credits INTEGER,date DATETIME,qty INTEGER)",
        );
        await db.execute(
          "CREATE TABLE item(ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,credits INTEGER,cat TEXT)",
        );
        await db.execute(
          "CREATE TABLE limits(ID INTEGER PRIMARY KEY AUTOINCREMENT,date DATETIME,credlimit INTEGER)",
        );
      },
      version: _version,
    );
  }

  Future<void> newdata(totalcredits, creditsleft, resetdate) async {
    final db = await getDB();
    await db.execute(
      "INSERT INTO data(totalcredits,creditsleft,resetdate) VALUES ($totalcredits,$creditsleft,'$resetdate')",
    );
  }

  Future<void> newItem(name, price) async {
    final db = await getDB();
    await db.execute("INSERT INTO item(name,credits) VALUES ('$name',$price)");
  }

  Future<void> newLimit(date, credlimit) async {
    final db = await getDB();
    await db.execute(
      "INSERT INTO limits(date,credlimit) VALUES ('$date',$credlimit)",
    );
  }

  Future<void> buy(int value) async {
    final db = await getDB();
    await db.rawUpdate("UPDATE data SET creditsleft=? where id = ?", [
      value,
      1,
    ]);
  }

  Future<void> order(List<OrderedItem> items, price) async {
    final db = await getDB();
    for (int i = 0; i < items.length; i++) {
      await db.execute(
        "INSERT INTO orderdata(name,credits,date,qty) VALUES ('${items[i].name}','${items[i].price}','${DateTime.now()}','${items[i].qty}')",
      );
    }
    final List<Map<String, dynamic>> result = await db.query(
      "data",
      where: "id= ?",
      whereArgs: [1],
    );
    int creditsLeft = result[0]["creditsleft"];
    await db.rawUpdate("UPDATE data SET creditsleft=? where id = ?", [
      creditsLeft - price,
      1,
    ]);
  }

  Future<void> updatecredits(int value) async {
    final db = await getDB();
    await db.rawUpdate("UPDATE data SET totalcredits=? where id = ?", [
      value,
      1,
    ]);
  }

  Future<void> updateresetdate(value) async {
    final db = await getDB();
    await db.rawUpdate("UPDATE data SET resetdate=? where id = ?", [
      '$value',
      1,
    ]);
  }

  Future<void> updatecreditsleft(int value) async {
    final db = await getDB();
    await db.rawUpdate("UPDATE data SET creditsleft=? where id = ?", [
      value,
      1,
    ]);
  }

  Future<void> updateLimit(credlimit, date) async {
    final db = await getDB();
    await db.rawUpdate("UPDATE limits SET credlimit=?, date=? where id = ?", [
      credlimit,
      '$date',
      1,
    ]);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await getDB();
    final List<Map<String, dynamic>> result = await db.query(
      "data",
      where: "id= ?",
      whereArgs: [1],
    );
    db.close();
    return result;
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await getDB();
    final List<Map<String, dynamic>> result = await db.query("item");
    db.close();
    return result;
  }

  Future<List<Map<String, dynamic>>> gettodaysSpendings(date) async {
    final db = await getDB();
    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT * FROM orderdata WHERE DATE(date) = ?",
      [date],
    );
    db.close();
    return result;
  }

  Future<List<Map<String, dynamic>>> getLimit() async {
    final db = await getDB();
    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT * FROM limits WHERE id = ?",
      [1],
    );
    db.close();
    return result;
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await getDB();
    final List<Map<String, dynamic>> result = await db.query("orderdata");
    db.close();
    return result;
  }
}
