import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  Portfolio({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Portfolio worth'),
                    percentChange(),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("\$" + 435.51.toString(),
                          style: TextStyle(fontSize: 36)),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {},
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

Widget percentChange() {
  return Align(
    alignment: Alignment.topRight,
    child: RichText(
      text: TextSpan(
        text: "+3.67%",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
      ),
    ),
  );
}
