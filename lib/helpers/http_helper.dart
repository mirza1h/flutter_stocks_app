import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stocks_app/models/stock.dart';

final apiKey = "?apikey=0aa8fabc3a8472e2a2a6c644611d099d";

class HttpHelper {
  static Future<Stock> fetchStock(String stockTicker) async {
    var url = "https://financialmodelingprep.com/api/v3/quote/" +
        stockTicker +
        apiKey;
    final response = await http.get(url);
    return Stock.fromJson(jsonDecode(response.body)[0]);
  }

  static Future<List<Stock>> fetchStocks(String stockTickers) async {
    var url = "https://financialmodelingprep.com/api/v3/quote/" +
        stockTickers +
        apiKey;
    final response = await http.get(url);
    List<Stock> stocks = (json.decode(response.body) as List)
        .map((i) => Stock.fromJson(i))
        .toList();
    return stocks;
  }
}
