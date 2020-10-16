import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/helpers/ui_helper.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/pages/stock_detail_page.dart';

class StockList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StockListState();
  }
}

class _StockListState extends State<StockList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Stock>>(
        future:
            HttpHelper.fetchStocks("AAPL,GOOG,AMZN,MSFT,FB,NKE,TSLA,CVX,DIS"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey);
              },
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final stock = snapshot.data[index];
                return ListTile(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StockDetail(stock: stock)))
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${stock.symbol}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${stock.name}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        "\$${stock.price}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 75,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "${stock.change}",
                            style: UIHelper.returnChangeColor(stock.change),
                          )),
                    ],
                  ),
                );
              },
            );
          } else
            return Container();
        });
  }
}
