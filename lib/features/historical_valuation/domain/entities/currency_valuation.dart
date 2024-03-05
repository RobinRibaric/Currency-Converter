class HistoricalValuationRate {
  final String currency;
  final double difference;
  final double rateFrom;
  final double rateTo;
  final double inverseFrom;
  final double inverseTo;

  HistoricalValuationRate({
    required this.currency,
    required this.difference,
    required this.rateFrom,
    required this.rateTo,
    required this.inverseFrom,
    required this.inverseTo,
  });

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'difference': difference,
      'rateFrom': rateFrom,
      'rateTo': rateTo,
      'inverseFrom': inverseFrom,
      'inverseTo': inverseTo,
    };
  }
}
