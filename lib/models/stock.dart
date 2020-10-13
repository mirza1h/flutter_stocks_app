import 'package:stocks_app/helpers/http_helper.dart';

class Stock {
  final String name;
  final String symbol;
  final double price;
  final double change;

  Stock({this.name, this.symbol, this.price, this.change});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        name: json['name'],
        symbol: json['symbol'],
        price: json['price'],
        change: json['change']);
  }

  static List<Future<Stock>> getAll() {
    List<Future<Stock>> stocks = List<Future<Stock>>();
    Future<Stock> stock = HttpHelper.fetchStock("AAPL");
    stocks.add(stock);
    return stocks;
  }
}
