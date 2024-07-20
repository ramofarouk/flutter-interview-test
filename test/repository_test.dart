import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_interview/core/entities/repository.dart';
import 'package:flutter_interview/core/usecases/fetch_trending_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_interview/presentation/bloc/repository_bloc.dart';
import 'package:flutter_interview/presentation/bloc/repository_event.dart';
import 'package:flutter_interview/presentation/bloc/repository_state.dart';

class MockFetchTrendingRepositories extends Mock implements FetchTrendingRepositories {}

void main() {
  late RepositoryBloc repositoryBloc;
  late MockFetchTrendingRepositories mockFetchTrendingRepositories;

  setUp(() {
    mockFetchTrendingRepositories = MockFetchTrendingRepositories();
    repositoryBloc = RepositoryBloc(mockFetchTrendingRepositories);
  });

  tearDown(() {
    repositoryBloc.close();
  });

  final repository = Repository(name: 'repo', description: 'description', language: 'Dart');
  final repositories = [repository];
  final result = {
    'repositories': repositories,
    'endCursor': 'endCursor',
    'hasNextPage': true,
  };

  group('RepositoryBloc', () {
    blocTest<RepositoryBloc, RepositoryState>(
      'emits [RepositoryLoading, RepositoryLoaded] when FetchRepositories is added',
      build: () {
        when(mockFetchTrendingRepositories.call())
            .thenAnswer((_) async => result);
        return repositoryBloc;
      },
      act: (bloc) => bloc.add(FetchRepositories()),
      expect: () => [
        RepositoryLoading(),
        RepositoryLoaded(repositories, repositories),
      ],
    );

    blocTest<RepositoryBloc, RepositoryState>(
      'emits [RepositoryLoading, RepositoryError] when FetchRepositories fails',
      build: () {
        when(mockFetchTrendingRepositories.call()).thenThrow(Exception('Error'));
        return repositoryBloc;
      },
      act: (bloc) => bloc.add(FetchRepositories()),
      expect: () => [
        RepositoryLoading(),
        RepositoryError('Exception: Error'),
      ],
    );

    blocTest<RepositoryBloc, RepositoryState>(
      'emits filtered repositories when FilterRepositoriesByLanguage is added',
      build: () {
        when(mockFetchTrendingRepositories.call())
            .thenAnswer((_) async => result);
        return repositoryBloc;
      },
      act: (bloc) {
        bloc.add(FetchRepositories());
        bloc.add(FilterRepositoriesByLanguage('Dart'));
      },
      expect: () => [
        RepositoryLoading(),
        RepositoryLoaded(repositories, repositories),
        RepositoryLoaded(repositories, repositories),
      ],
    );

    blocTest<RepositoryBloc, RepositoryState>(
      'emits [RepositoryLoaded] with more repositories when LoadMoreRepositories is added',
      build: () {
        when(mockFetchTrendingRepositories.call(after: 'endCursor'))
            .thenAnswer((_) async => result);
        return repositoryBloc;
      },
      seed: () => RepositoryLoaded(repositories, repositories),
      act: (bloc) => bloc.add(LoadMoreRepositories()),
      expect: () => [
        RepositoryLoaded([...repositories, ...repositories], [...repositories, ...repositories]),
      ],
    );
  });
}