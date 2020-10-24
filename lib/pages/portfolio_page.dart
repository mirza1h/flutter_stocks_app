import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/db_helper.dart';
import 'package:stocks_app/widgets/portfolio_header.dart';
import 'package:stocks_app/widgets/stock_list.dart';

class Portfolio extends StatelessWidget {
  Portfolio({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(children: [
        PortfolioHeader(),
        StockList(DbHelper.currentUser, false),
      ]),
    );
  }
}
