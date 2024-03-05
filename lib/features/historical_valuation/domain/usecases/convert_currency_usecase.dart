import 'package:currency_converter/features/historical_valuation/domain/entities/currency_valuation.dart';
import 'package:currency_converter/features/historical_valuation/domain/repositories/historical_valuation_repository.dart';

class GetHistoricalValuationUseCase {
  final HistoricalValuationRepository historicalValuationRepository;

  GetHistoricalValuationUseCase({required this.historicalValuationRepository});

  Future<List<HistoricalValuationRate>> execute(String fromDate, String toDate, String currency) async {
    try {
      Map<String, dynamic> historicRates = await historicalValuationRepository.getHistoricalValuationData(fromDate, toDate, currency);
      List<HistoricalValuationRate> valuationDifferences = [];

      // loop through historicRates["ratesFrom"] and historicRates["ratesTo"] and calculate the difference
      // between the two rates for each date and store the result in a new map
      // return the new map
      for (var rateFrom in historicRates['ratesFrom']) {
        // Find the matching currency in the second date's rates
        var rateTo = historicRates['ratesTo'].firstWhere(
          (r) => r['currency'] == rateFrom['currency'],
          orElse: () => null,
        );

        // if currency is equal to the base currency, skip it
        if (rateFrom['currency'] == currency || rateTo['currency'] == currency) {
          continue;
        }

        if (rateTo != null) {
          var difference = rateTo['rate'] - rateFrom['rate'];
          valuationDifferences.add(HistoricalValuationRate(
            currency: rateFrom['currency'],
            difference: difference,
            rateFrom: rateFrom['rate'],
            rateTo: rateTo['rate'],
            inverseFrom: rateFrom['inverse'],
            inverseTo: rateTo['inverse'],
          ));
        }
      }

      return valuationDifferences;
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
