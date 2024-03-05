import 'package:equatable/equatable.dart';

abstract class CurrencyState extends Equatable {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double conversionResult;

  // every time fromCurrency or toCurrency changes,

  const CurrencyState({
    this.fromCurrency = 'SEK - Swedish Krona',
    this.toCurrency = 'EUR - Euro',
    this.amount = 1,
    this.conversionResult = 0.0,
  });

  @override
  List<Object?> get props => [fromCurrency, toCurrency, amount];
}

extension CurrencyStateExtension on CurrencyState {
  String get fromCurrencyCode => fromCurrency.split(" - ")[0];
  String get toCurrencyCode => toCurrency.split(" - ")[0];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {
  const CurrencyLoading({
    super.fromCurrency,
    super.toCurrency,
    required super.conversionResult,
    super.amount,
  });
}

class CurrencyLoaded extends CurrencyState {
  const CurrencyLoaded({
    super.fromCurrency,
    super.toCurrency,
    required super.conversionResult,
    super.amount,
  });
}

class CurrencyError extends CurrencyState {
  final String message;

  CurrencyError(this.message);

  @override
  List<Object?> get props => super.props..add(message);
}

class CurrencySwappedState extends CurrencyState {
  const CurrencySwappedState({
    required super.fromCurrency,
    required super.toCurrency,
    super.amount,
  }) : super();

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

// Update toCurrency
class UpdateToCurrencyState extends CurrencyState {
  const UpdateToCurrencyState({
    required super.toCurrency,
  }) : super();
}

// Update fromCurrency
class UpdateFromCurrencyState extends CurrencyState {
  const UpdateFromCurrencyState({
    required super.fromCurrency,
  }) : super();
}
