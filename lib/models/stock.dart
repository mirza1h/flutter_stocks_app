import 'package:stocks_app/helpers/http_helper.dart';

class Stock {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final double dayLow;
  final double dayHigh;
  final double marketCap;
  final int volume;
  final String exchange;
  final double open;
  final String earningsAnnouncement;

  Stock(
      {this.dayLow,
      this.dayHigh,
      this.marketCap,
      this.volume,
      this.exchange,
      this.open,
      this.earningsAnnouncement,
      this.name,
      this.symbol,
      this.price,
      this.change});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      name: json['name'],
      symbol: json['symbol'],
      price: json['price'],
      change: json['change'],
      dayLow: json['dayLow'],
      dayHigh: json['dayHigh'],
      marketCap: json['marketCap'],
      volume: json['volume'],
      exchange: json['exchange'],
      open: json['open'],
      earningsAnnouncement: json['earningsAnnouncement'],
    );
  }

  static List<Future<Stock>> getAll() {
    List<Future<Stock>> stocks = List<Future<Stock>>();
    Future<Stock> stock = HttpHelper.fetchStock("AAPL");
    stocks.add(stock);
    return stocks;
  }
}
