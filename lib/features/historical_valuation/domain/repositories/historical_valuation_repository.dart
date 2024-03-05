abstract class HistoricalValuationRepository {
  Future<Map<String, dynamic>> getHistoricalValuationData(String fromDate, String toDate, String currency);
}
