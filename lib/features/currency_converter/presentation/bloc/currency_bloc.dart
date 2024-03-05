import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/features/currency_converter/domain/usecases/convert_currency_usecase.dart';
import 'package:currency_converter/features/currency_converter/presentation/bloc/currency_event.dart';
import 'package:currency_converter/features/currency_converter/presentation/bloc/currency_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository currencyRepository;
  final ConvertCurrencyUseCase convertCurrencyUseCase;

  CurrencyBloc({required this.convertCurrencyUseCase, required this.currencyRepository}) : super(CurrencyInitial()) {
    on<ConvertCurrency>((event, emit) async {
      // Emit loading state
      emit(CurrencyLoading(
          conversionResult: state.conversionResult, toCurrency: state.toCurrency, amount: event.amount, fromCurrency: state.fromCurrency));
      try {
        // Fetch the conversion result
        Map<String, dynamic> data = await convertCurrencyUseCase.execute(event.amount, state.fromCurrencyCode, state.toCurrencyCode);

        // Emit loaded state
        emit(CurrencyLoaded(
            conversionResult: data['conversionResult'], toCurrency: state.toCurrency, amount: event.amount, fromCurrency: state.fromCurrency));
      } catch (e) {
        // Emit error state
        emit(CurrencyError(e.toString()));
      }
    });

    on<SwapCurrenciesEvent>((event, emit) async {
      // Swap the currencies
      final fromCurrency = state.toCurrency;
      final temp = state.fromCurrency;
      final toCurrency = temp;

      // convert
      if (state is CurrencyLoaded) {
        Map<String, dynamic> data = await convertCurrencyUseCase.execute(state.amount, fromCurrency.split(" ")[0], toCurrency.split(" ")[0]);
        emit(CurrencyLoaded(fromCurrency: fromCurrency, toCurrency: toCurrency, conversionResult: data['conversionResult'], amount: state.amount));
      } else {
        emit(CurrencySwappedState(fromCurrency: fromCurrency, toCurrency: toCurrency, amount: state.amount));
      }
    });

    // Update fromCurrency
    on<UpdateFromCurrencyEvent>((event, emit) {
      emit(UpdateFromCurrencyState(fromCurrency: event.fromCurrency));
    });

    // Update toCurrency
    on<UpdateToCurrencyEvent>((event, emit) {
      emit(UpdateToCurrencyState(toCurrency: event.toCurrency));
    });

    // Fetch initial currency data
    on<FetchInitialCurrencyData>((event, emit) async {
      try {
        emit(CurrencyLoading(conversionResult: state.conversionResult));
        Map<String, dynamic> data = await convertCurrencyUseCase.execute(state.amount, state.fromCurrencyCode, state.toCurrencyCode);
        emit(CurrencyLoaded(
            fromCurrency: state.fromCurrency, toCurrency: state.toCurrency, conversionResult: data['conversionResult'], amount: state.amount));
      } catch (error) {
        emit(CurrencyError(error.toString()));
      }
    });
  }
}
