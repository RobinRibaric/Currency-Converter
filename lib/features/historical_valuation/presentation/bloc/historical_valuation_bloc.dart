import 'package:currency_converter/features/historical_valuation/domain/entities/currency_valuation.dart';
import 'package:currency_converter/features/historical_valuation/domain/repositories/historical_valuation_repository.dart';
import 'package:currency_converter/features/historical_valuation/domain/usecases/convert_currency_usecase.dart';
import 'package:currency_converter/features/historical_valuation/presentation/bloc/historical_valuation_event.dart';
import 'package:currency_converter/features/historical_valuation/presentation/bloc/historical_valuation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoricalValuationBloc extends Bloc<HistoricalValuationEvent, HistoricalValuationState> {
  final HistoricalValuationRepository historicalValuationRepository;
  final GetHistoricalValuationUseCase getHistoricalValuationUseCase;

  HistoricalValuationBloc({required this.getHistoricalValuationUseCase, required this.historicalValuationRepository})
      : super(HistoricalValuationInitial()) {
    // Fetch historical valuation data
    on<GetHistoricalValuationData>((event, emit) async {
      emit(HistoricalValuationLoading(currency: state.currency, fromDate: state.fromDate, toDate: state.toDate, historicRates: state.historicRates));
      try {
        List<HistoricalValuationRate> data =
            await getHistoricalValuationUseCase.execute(state.formattedFromDate, state.formattedToDate, state.currencyCode);
        emit(HistoricalValuationLoaded(currency: state.currency, fromDate: state.fromDate, toDate: state.toDate, historicRates: data));
      } catch (e) {
        emit(HistoricalValuationError(e.toString()));
      }
    });

    // Update from date
    on<UpdateFromDateEvent>((event, emit) {
      emit(UpdateFromDate(fromDate: event.fromDate));
    });

    // Update to date
    on<UpdateToDateEvent>((event, emit) {
      emit(UpdateToDate(toDate: event.toDate));
    });

    // Update currency
    on<UpdateCurrencyEvent>((event, emit) {
      emit(UpdateCurrency(currency: event.currency));
    });
  }
}
