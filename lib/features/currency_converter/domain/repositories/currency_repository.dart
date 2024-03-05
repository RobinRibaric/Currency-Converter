abstract class CurrencyRepository {
  Future<Map<String, dynamic>> getConversionRateData(String fromCurrency, String toCurrency);
}
