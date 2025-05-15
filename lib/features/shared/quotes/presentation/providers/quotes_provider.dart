import 'package:anchor/features/shared/quotes/data/datasources/quote_local_datasource.dart';
import 'package:anchor/features/shared/quotes/data/repositories/quote_repository_impl.dart';
import 'package:anchor/features/shared/quotes/domain/entities/quote.dart';
import 'package:anchor/features/shared/quotes/domain/repositories/quote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quoteLocalDataSourceProvider = Provider<QuoteLocalDataSource>((ref) {
  return QuoteLocalDataSource();
});

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  final localDataSource = ref.read(quoteLocalDataSourceProvider);
  return QuoteRepositoryImpl(localDataSource);
});

final dailyQuoteProvider = FutureProvider<Quote>((ref) async {
  final repository = ref.read(quoteRepositoryProvider);
  return await repository.getDailyQuote();
});
