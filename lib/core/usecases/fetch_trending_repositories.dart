import 'package:flutter_interview/core/repositories/repository_repository.dart';

class FetchTrendingRepositories {
  final RepositoryRepository repository;

  FetchTrendingRepositories(this.repository);

  Future<Map<String, dynamic>> call({int first = 20, String? after}) {
    return repository.fetchTrendingRepositories(first: first, after: after);
  }
}
