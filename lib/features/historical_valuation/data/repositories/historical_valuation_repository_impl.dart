import 'dart:convert';

import 'package:currency_converter/features/historical_valuation/domain/repositories/historical_valuation_repository.dart';
import 'package:http/http.dart' as http;

class HistoricalValuationRepositoryImpl implements HistoricalValuationRepository {
  final http.Client client;

  HistoricalValuationRepositoryImpl({required this.client});
  @override
  Future<Map<String, dynamic>> getHistoricalValuationData(String fromDate, String toDate, String currency) async {
    Map<String, dynamic> request = {};

    Map<String, String> headers = {
      'authority': 'www.xe.com',
      'accept': '*/*',
      'accept-language': 'en-GB,en;q=0.9',
      'cookie':
          'lastConversion={%22amount%22:1%2C%22fromCurrency%22:%22SEK%22%2C%22toCurrency%22:%22EUR%22}; userId=19e5bfbe-9826-4672-a8a5-8035562a61c0; lastQuote={%22sendingAmount%22:1000%2C%22sendingCurrency%22:%22SEK%22%2C%22receivingAmount%22:88.1%2C%22receivingCurrency%22:%22EUR%22%2C%22fixedField%22:%22sending%22%2C%22destinationCountry%22:%22FR%22}; xeConsentState={%22performance%22:true%2C%22marketing%22:true%2C%22compliance%22:false}; amp_470887=skIJwUAv-AmA2cgxbEYV67...1hnrfa6h0.1hnr6doke.6.3.9',
      'referer': 'https://www.xe.com/sv/currencytables/?from=SEK&date=2015-02-12',
      'sec-ch-ua': '"Chromium";v="122", "Not(A:Brand";v="24", "Brave";v="122"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'same-origin',
      'sec-gpc': '1',
      'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
      'x-nextjs-data': '1'
    };

    final Uri startDateUrl = Uri.parse('https://www.xe.com/_next/data/ru9nVtPPbxLaF9lurGHqO/sv/currencytables.json?from=$currency&date=$fromDate');
    final Uri endDateUrl = Uri.parse('https://www.xe.com/_next/data/ru9nVtPPbxLaF9lurGHqO/sv/currencytables.json?from=$currency&date=$toDate');

    final startDateResponse = await client.get(startDateUrl, headers: headers);
    final endDateResponse = await client.get(endDateUrl, headers: headers);

    if (startDateResponse.statusCode == 200 && endDateResponse.statusCode == 200) {
      request["ratesFrom"] = json.decode(startDateResponse.body)["pageProps"]["historicRates"];
      request["ratesTo"] = json.decode(endDateResponse.body)["pageProps"]["historicRates"];
    } else {
      throw Exception('Failed to load currency data');
    }

    return request;
  }
}
