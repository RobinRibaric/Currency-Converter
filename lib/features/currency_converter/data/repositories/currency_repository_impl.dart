import 'dart:convert';
import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';
import 'package:http/http.dart' as http;

class CurrencyRepositoryImpl implements CurrencyRepository {
  final http.Client client;

  CurrencyRepositoryImpl({required this.client});
  @override
  Future<Map<String, dynamic>> getConversionRateData(String fromCurrency, String toCurrency) async {
    Map<String, dynamic> request = {};
    String url = 'https://www.xe.com/api/protected/statistics/?from=$fromCurrency&to=$toCurrency';
    Map<String, String> headers = {
      'sec-ch-ua': '"Chromium";v="122", "Not(A:Brand";v="24", "Brave";v="122"',
      'Referer': 'https://www.xe.com/currencyconverter/convert/?Amount=1&From=SEK&To=EUR',
      'sec-ch-ua-mobile': '?0',
      'authorization': 'Basic bG9kZXN0YXI6cHVnc25heA==',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
      'sec-ch-ua-platform': '"Windows"',
    };

    final Uri uri = Uri.parse(url);

    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      request = json.decode(response.body);
    } else {
      throw Exception('Failed to load currency data');
    }

    return request;
  }
}
