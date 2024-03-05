// Currency Conversion Events
abstract class CurrencyEvent {}

class ConvertCurrency extends CurrencyEvent {
  final double amount;
  final String fromCurrency;
  final String toCurrency;

  ConvertCurrency(this.amount, this.fromCurrency, this.toCurrency);
}

class SwapCurrenciesEvent extends CurrencyEvent {}

// CurrencySwapped
class CurrencySwappedEvent extends CurrencyEvent {
  final String fromCurrency;
  final String toCurrency;

  CurrencySwappedEvent({required this.fromCurrency, required this.toCurrency});

  @override
  List<Object> get props => [fromCurrency, toCurrency];
}

class UpdateFromCurrencyEvent extends CurrencyEvent {
  final String fromCurrency;

  UpdateFromCurrencyEvent(this.fromCurrency);

  @override
  List<Object> get props => [fromCurrency];
}

class UpdateToCurrencyEvent extends CurrencyEvent {
  final String toCurrency;

  UpdateToCurrencyEvent(this.toCurrency);

  @override
  List<Object> get props => [toCurrency];
}

class FetchInitialCurrencyData extends CurrencyEvent {}
