import 'package:currency_converter/features/historical_valuation/domain/entities/currency_valuation.dart';
import 'package:flutter/material.dart';

class ValuationDifferenceList extends StatelessWidget {
  final List<HistoricalValuationRate> differences;
  final String currency;
  final DateTime fromDate;
  final DateTime toDate;

  const ValuationDifferenceList({
    super.key,
    required this.differences,
    required this.currency,
    required this.fromDate,
    required this.toDate,
  });

  String formatDifference(double difference) {
    return difference.sign == 1 ? "+${difference.toStringAsFixed(4)}" : difference.toStringAsFixed(4);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: differences.length,
      itemBuilder: (context, index) {
        final item = differences[index];
        // if currency is SEK, don't show SEK in the list
        if (item.currency == currency) {
          return const SizedBox.shrink();
        }
        // Calculate and format the percentage difference
        final differenceFormatted = formatDifference(item.difference);
        final positiveChange = item.difference > 0;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              backgroundColor: Colors.white,
              title: Text(item.currency, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Row(
                children: [
                  const Text('Change: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    differenceFormatted,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: positiveChange ? Colors.green : Colors.red),
                  ),
                ],
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Colors.grey,
                        height: 10,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                      Row(
                        children: [
                          const Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(fromDate.toIso8601String().substring(0, 10)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Unit per $currency: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${item.rateFrom}'),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 10,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                      Row(
                        children: [
                          const Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(toDate.toIso8601String().substring(0, 10)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Unit per $currency: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${item.rateTo}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
