import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/pages/stock_detail_page.dart';

class StockSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.close), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Stock>>(
        future: HttpHelper.fetchStockSuggestions(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final Stock stock = snapshot.data[index];
                  return ListTile(
                    title: Text("${stock.symbol}"),
                    subtitle: Text("${stock.name}"),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StockDetail(stock: stock)))
                    },
                  );
                });
          } else {
            return Container();
          }
        });
  }
}
