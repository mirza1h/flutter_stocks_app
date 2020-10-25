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
  int quantity;
  double boughtAt;
  double soldAt;

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
      this.change,
      this.quantity,
      this.boughtAt,
      this.soldAt});

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
      earningsAnnouncement: json['earningsAnnouncement'] != null
          ? json['earningsAnnouncement'].toString().substring(0, 10)
          : 'N/A',
    );
  }
}
