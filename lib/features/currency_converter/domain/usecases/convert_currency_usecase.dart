import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';

class ConvertCurrencyUseCase {
  final CurrencyRepository currencyRepository;

  ConvertCurrencyUseCase({required this.currencyRepository});

  Future<Map<String, dynamic>> execute(double amount, String fromCurrencyCode, String toCurrencyCode) async {
    if (amount <= 0) {
      throw InvalidInputException('Amount must be greater than zero.');
    }

    try {
      Map<String, dynamic> data = await currencyRepository.getConversionRateData(fromCurrencyCode, toCurrencyCode);
      double conversionResult = amount * data['last1Days']['average'];
      String toCurrency = data['last1Days']['to'];

      return {'conversionResult': conversionResult, 'toCurrency': toCurrency};
    } catch (error) {
      rethrow;
    }
  }
}

class InvalidInputException implements Exception {
  final String message;
  InvalidInputException(this.message);

  @override
  String toString() => message;
}
