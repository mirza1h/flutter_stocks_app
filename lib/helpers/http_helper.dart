import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/models/stock_chart.dart';
import 'package:stocks_app/models/stock_day.dart';

final apiKey = "apikey=0aa8fabc3a8472e2a2a6c644611d099d";
final baseURL = "https://financialmodelingprep.com/api/v3/";

class HttpHelper {
  static Future<Stock> fetchStock(String stockTicker) async {
    var url = baseURL + "quote/" + stockTicker + "?" + apiKey;
    final response = await http.get(url);
    return Stock.fromJson(jsonDecode(response.body)[0]);
  }

  static Future<List<Stock>> fetchStocks(String stockTickers) async {
    var url = baseURL + "quote/" + stockTickers + "?" + apiKey;
    final response = await http.get(url);
    List<Stock> stocks = (json.decode(response.body) as List)
        .map((i) => Stock.fromJson(i))
        .toList();
    return stocks;
  }

  static Future<StockChart> fetchStockHistoricalData(
      String stockTicker, int interval) async {
    var currentDateTime = new DateTime.now();
    var fromDateTime = currentDateTime.subtract(Duration(days: interval));
    var formatter = new DateFormat('yyyy-MM-dd');
    String toDate = formatter.format(currentDateTime);
    String fromDate = formatter.format(fromDateTime);
    var url = baseURL +
        "historical-price-full/" +
        stockTicker +
        "?from=" +
        fromDate +
        "&to=" +
        toDate +
        "&" +
        apiKey;
    final response = await http.get(url);

    List<Map<String, dynamic>> stocks =
        (json.decode(response.body)['historical'] as List)
            .map((i) => StockDay.fromJson(i).toMap())
            .toList();
    StockChart stockChart = StockChart(stockChart: stocks);
    return stockChart;
  }
}
