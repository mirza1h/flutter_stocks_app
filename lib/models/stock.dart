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
  final int quantity = 12;
  final double boughtAt = 21.43;
  final double soldAt;

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
      this.soldAt});

  factory Stock.fromJson(Map<String, dynamic> json) {
    var earningsAnnouncement = json['earningsAnnouncement'];
    if (earningsAnnouncement != null) {
      try {
        earningsAnnouncement = earningsAnnouncement.toString().substring(0, 10);
      } catch (e) {
        print(e);
      }
    }
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
