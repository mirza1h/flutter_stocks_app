import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/db_helper.dart';
import 'package:stocks_app/widgets/portfolio_header.dart';
import 'package:stocks_app/widgets/stock_list.dart';

class Portfolio extends StatefulWidget {
  Portfolio({Key key}) : super(key: key);

  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  StreamController<bool> headerRebuildCtr = StreamController<bool>();

  @override
  void dispose() {
    headerRebuildCtr.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(children: [
        StreamBuilder(
          stream: headerRebuildCtr.stream,
          builder: (context, snapshot) {
            return PortfolioHeader();
          },
        ),
        StockList(DbHelper.currentUser, false, headerRebuildCtr),
      ]),
    );
  }
}
