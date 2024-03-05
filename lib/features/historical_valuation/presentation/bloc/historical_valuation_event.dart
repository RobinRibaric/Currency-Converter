// Currency Conversion Events
abstract class HistoricalValuationEvent {}

class GetHistoricalValuationData extends HistoricalValuationEvent {}

class UpdateFromDateEvent extends HistoricalValuationEvent {
  final DateTime fromDate;

  UpdateFromDateEvent(this.fromDate);
}

class UpdateToDateEvent extends HistoricalValuationEvent {
  final DateTime toDate;

  UpdateToDateEvent(this.toDate);
}

class UpdateCurrencyEvent extends HistoricalValuationEvent {
  final String currency;

  UpdateCurrencyEvent(this.currency);
}
