import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Historyitem extends StatelessWidget {
  const Historyitem({
    super.key,
    required this.name,
    required this.date,
    required this.qty,
    required this.price,
  });
  final String name;
  final String date;
  final int qty;
  final int price;

  String get formattedDate {
    DateTime dateTime = DateTime.parse(date);

    String formatted = DateFormat("MMMM d, y h:mm a").format(dateTime);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDate,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("qty : $qty", style: GoogleFonts.roboto(fontSize: 15)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₹${price * qty}",
                  style: GoogleFonts.roboto(
                    color: Colors.red,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
