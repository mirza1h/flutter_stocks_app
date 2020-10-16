import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:stocks_app/models/news.dart';
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
    var url = baseURL +
        "historical-price-full/" +
        stockTicker +
        "?timeseries=" +
        interval.toString() +
        "&" +
        apiKey;
    final response = await http.get(url);
    List stockList = json.decode(response.body)['historical'];
    List reversedList = new List.from(stockList.reversed);
    List<Map<String, dynamic>> stocks =
        reversedList.map((i) => StockDay.fromJson(i).toMap()).toList();
    StockChart stockChart = StockChart(stockChart: stocks);
    return stockChart;
  }

  static Future<List<News>> fetchNews(int limit) async {
    var url = baseURL + "stock_news?limit=" + limit.toString() + "&" + apiKey;
    final response = await http.get(url);
    List<News> newsList = (json.decode(response.body) as List)
        .map((i) => News.fromJson(i))
        .toList();
    return newsList;
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
