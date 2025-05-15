import 'package:anchor/features/shared/quotes/domain/entities/quote.dart';

abstract class QuoteRepository {
  Future<Quote> getDailyQuote();
}
