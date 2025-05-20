import 'package:anchor/features/shared/quotes/data/datasources/quote_local_datasource.dart';
import 'package:anchor/features/shared/quotes/domain/entities/quote.dart';
import 'package:anchor/features/shared/quotes/domain/repositories/quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteLocalDataSource localDataSource;

  QuoteRepositoryImpl(this.localDataSource);

  @override
  Future<Quote> getDailyQuote() {
    return localDataSource.getDailyQuote();
  }

  @override
  Future<Quote> getRandomQuote() {
    return localDataSource.getRandomQuote();
  }
}
