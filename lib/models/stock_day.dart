class StockDay {
  final double open;
  final double close;
  final double low;
  final double high;
  final double volumeto;

  StockDay({this.open, this.close, this.low, this.high, this.volumeto});

  factory StockDay.fromJson(Map<String, dynamic> json) {
    return StockDay(
      open: json['open'],
      close: json['close'],
      low: json['low'],
      high: json['high'],
      volumeto: json['volume'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'open': this.open,
      'close': this.close,
      'low': this.low,
      'high': this.high,
      'volumeto': this.volumeto,
    };
  }
}
