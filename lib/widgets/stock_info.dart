import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stocks_app/models/stock.dart';

class StockInfo extends StatelessWidget {
  Stock stock;
  StockInfo(Stock stock) {
    this.stock = stock;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: <Widget>[
        ListTile(
          leading: FaIcon(FontAwesomeIcons.exchangeAlt),
          title: Text(
            "Exchange",
          ),
          trailing: Text("${stock.exchange}"),
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.shoppingCart),
          title: Text("Market capitalization"),
          trailing: Text("${stock.marketCap}"),
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.dollarSign),
          title: Text("Day low"),
          trailing: Text("${stock.dayLow}"),
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.dollarSign),
          title: Text("Day high"),
          trailing: Text("${stock.dayHigh}"),
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.database),
          title: Text("Volume"),
          trailing: Text("${stock.volume}"),
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.businessTime),
          title: Text("Earnings announcement"),
          trailing: Text("${stock.earningsAnnouncement}"),
        )
      ]),
    );
  }
}
