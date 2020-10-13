import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/widgets/stock_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Stocks",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      "October 11",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              hintText: "Search",
                              prefix: Icon(Icons.search),
                              fillColor: Colors.grey[500],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: StockList()),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
