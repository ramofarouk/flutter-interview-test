import 'package:flutter_interview/core/repositories/repository_repository.dart';
import 'package:flutter_interview/core/usecases/fetch_trending_repositories.dart';
import 'package:flutter_interview/data/datasources/github_graphql_api.dart';
import 'package:flutter_interview/data/repositories/repository_repository_impl.dart';
import 'package:flutter_interview/presentation/bloc/repository_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final sl = GetIt.instance;

void setup() {
  // GraphQL Client
  final HttpLink httpLink = HttpLink('https://api.github.com/graphql');
  final AuthLink authLink =
      AuthLink(getToken: () async => 'Bearer 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');
  final Link link = authLink.concat(httpLink);

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: link,
  );

  // External
  sl.registerLazySingleton(() => client);

  // Data sources
  sl.registerLazySingleton(() => GithubGraphQLApi(sl()));

  // Repositories
  sl.registerLazySingleton<RepositoryRepository>(
      () => RepositoryRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => FetchTrendingRepositories(sl()));

  // Blocs
  sl.registerFactory(() => RepositoryBloc(sl()));
}
