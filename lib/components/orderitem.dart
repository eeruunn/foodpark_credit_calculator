import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.name,
    required this.price,
    required this.addtocart,
    required this.qty,
  });
  final String name;
  final int price;
  final int qty;
  final void Function(int qty) addtocart;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.addtocart(1);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: double.infinity,
          height: 100,
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
                        "${widget.name}",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹${widget.price}",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.qty > 0) {
                              setState(() {
                                widget.addtocart(-1);
                              });
                            }
                          },
                          icon: Icon(Icons.remove, color: Colors.red, size: 35),
                        ),
                        Text(
                          "${widget.qty}",
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.addtocart(1);
                            });
                          },
                          icon: Icon(Icons.add, color: Colors.green, size: 35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
