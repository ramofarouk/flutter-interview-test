import 'package:flutter_interview/core/repositories/repository_repository.dart';
import 'package:flutter_interview/data/datasources/github_graphql_api.dart';

class RepositoryRepositoryImpl implements RepositoryRepository {
  final GithubGraphQLApi api;

  RepositoryRepositoryImpl(this.api);

  @override
  Future<Map<String, dynamic>> fetchTrendingRepositories({int first = 20, String? after}) {
    return api.fetchTrendingRepositories(first: first, after: after);
  }
}
