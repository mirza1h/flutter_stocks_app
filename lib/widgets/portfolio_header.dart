import 'package:flutter/material.dart';

class PortfolioHeader extends StatefulWidget {
  PortfolioHeader({Key key}) : super(key: key);

  @override
  _PortfolioHeaderState createState() => _PortfolioHeaderState();
}

class _PortfolioHeaderState extends State<PortfolioHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      height: 140,
      child: Card(
        color: Colors.white70,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
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
