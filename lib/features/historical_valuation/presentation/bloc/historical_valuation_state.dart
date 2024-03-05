import 'package:currency_converter/features/historical_valuation/domain/entities/currency_valuation.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

// Historical Valuation State
abstract class HistoricalValuationState extends Equatable {
  final String currency;
  final DateTime fromDate;
  final DateTime toDate;
  final List<HistoricalValuationRate> historicRates;

  HistoricalValuationState({
    this.currency = 'SEK - Swedish Krona',
    DateTime? fromDate,
    DateTime? toDate,
    this.historicRates = const [],
  })  : fromDate = fromDate ?? DateTime(2015, 3, 26),
        toDate = toDate ?? DateTime(2017, 6, 13);

  @override
  List<Object?> get props => [currency, fromDate, toDate];
}

extension HistoricalValuationStateExtension on HistoricalValuationState {
  String get formattedFromDate => DateFormat('yyyy-MM-dd').format(fromDate);
  String get formattedToDate => DateFormat('yyyy-MM-dd').format(toDate);
  String get currencyCode => currency.split(" - ")[0];
}

// LOADING
class HistoricalValuationLoading extends HistoricalValuationState {
  HistoricalValuationLoading({
    super.currency,
    super.fromDate,
    super.toDate,
    super.historicRates,
  });
}

// LOADED
class HistoricalValuationLoaded extends HistoricalValuationState {
  HistoricalValuationLoaded({
    super.currency,
    super.fromDate,
    super.toDate,
    required super.historicRates,
  });
}

// INITIAL
class HistoricalValuationInitial extends HistoricalValuationState {}

// ERROR
class HistoricalValuationError extends HistoricalValuationState {
  final String message;

  HistoricalValuationError(this.message);

  @override
  List<Object?> get props => super.props..add(message);
}

// update currency
class UpdateCurrency extends HistoricalValuationState {
  UpdateCurrency({required super.currency}) : super();

  @override
  List<Object?> get props => super.props..add(currency);
}

// update from date
class UpdateFromDate extends HistoricalValuationState {
  UpdateFromDate({required super.fromDate}) : super();

  @override
  List<Object?> get props => super.props..add(fromDate);
}

// update to date
class UpdateToDate extends HistoricalValuationState {
  UpdateToDate({required super.toDate}) : super();

  @override
  List<Object?> get props => super.props..add(toDate);
}
