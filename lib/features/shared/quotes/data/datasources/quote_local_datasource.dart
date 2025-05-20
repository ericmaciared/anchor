import 'package:anchor/features/shared/quotes/domain/entities/quote.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class QuoteLocalDataSource {
  static final QuoteLocalDataSource _instance =
      QuoteLocalDataSource._internal();

  factory QuoteLocalDataSource() => _instance;

  QuoteLocalDataSource._internal();

  List<Quote>? _cachedQuotes;

  Future<List<Quote>> _loadQuotes() async {
    if (_cachedQuotes != null) return _cachedQuotes!;

    final csvData = await rootBundle.loadString('assets/quotes/quotes.csv');
    final List<List<dynamic>> rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvData);

    // Skip header
    final quotes = rows.skip(1).map((row) {
      return Quote(
        author: row[0] as String,
        text: row[1] as String,
      );
    }).toList();

    _cachedQuotes = quotes;
    return quotes;
  }

  Future<Quote> getRandomQuote() async {
    final quotes = await _loadQuotes();
    final random =
        quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
    return random;
  }

  Future<Quote> getDailyQuote() async {
    final quotes = await _loadQuotes();
    final today = DateTime.now();
    final dayOfYear = int.parse(DateFormat("D").format(today));
    final index = dayOfYear % quotes.length;
    return quotes[index];
  }
}
