import 'package:currency_converter/features/currency_converter/domain/usecases/convert_currency_usecase.dart';
import 'package:currency_converter/features/currency_converter/presentation/bloc/currency_bloc.dart';
import 'package:currency_converter/features/historical_valuation/data/repositories/historical_valuation_repository_impl.dart';
import 'package:currency_converter/features/historical_valuation/domain/repositories/historical_valuation_repository.dart';
import 'package:currency_converter/features/historical_valuation/domain/usecases/convert_currency_usecase.dart';
import 'package:currency_converter/features/historical_valuation/presentation/bloc/historical_valuation_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:currency_converter/features/currency_converter/data/repositories/currency_repository_impl.dart';
import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<CurrencyRepository>(() => CurrencyRepositoryImpl(client: getIt<http.Client>()));
  getIt.registerLazySingleton<HistoricalValuationRepository>(() => HistoricalValuationRepositoryImpl(client: getIt<http.Client>()));

  // Register CurrencyBloc
  getIt.registerFactory<CurrencyBloc>(() => CurrencyBloc(
      convertCurrencyUseCase: ConvertCurrencyUseCase(currencyRepository: getIt<CurrencyRepository>()),
      currencyRepository: getIt<CurrencyRepository>()));

  // Register HistoricalValuationBloc
  getIt.registerFactory<HistoricalValuationBloc>(() => HistoricalValuationBloc(
      getHistoricalValuationUseCase: GetHistoricalValuationUseCase(historicalValuationRepository: getIt<HistoricalValuationRepository>()),
      historicalValuationRepository: getIt<HistoricalValuationRepository>()));
}
