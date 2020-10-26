import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/db_helper.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/helpers/ui_helper.dart';
import 'package:stocks_app/pages/home_page.dart';

class PortfolioHeader extends StatefulWidget {
  PortfolioHeader({Key key}) : super(key: key);

  @override
  _PortfolioHeaderState createState() => _PortfolioHeaderState();
}

class _PortfolioHeaderState extends State<PortfolioHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: Colors.white70,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                          "\$" + HttpHelper.portfolioWorth.toStringAsFixed(2),
                          style: TextStyle(fontSize: 36)),
                    ),
                    percentChange(),
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
        text: HttpHelper.portfolioChange.toStringAsFixed(2) + "%",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: UIHelper.returnChangeColor(HttpHelper.portfolioChange).color,
            fontSize: 20),
      ),
    ),
  );
}
