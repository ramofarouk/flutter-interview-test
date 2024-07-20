import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interview/core/entities/repository.dart';
import 'package:flutter_interview/core/usecases/fetch_trending_repositories.dart';
import 'package:flutter_interview/presentation/bloc/repository_event.dart';
import 'package:flutter_interview/presentation/bloc/repository_state.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final FetchTrendingRepositories fetchTrendingRepositories;
  String? endCursor;
  bool hasNextPage = true;

  RepositoryBloc(this.fetchTrendingRepositories) : super(RepositoryInitial()) {
    on<FetchRepositories>(_onFetchRepositories);
    on<FilterRepositoriesByLanguage>(_onFilterRepositoriesByLanguage);
    on<FilterRepositoriesChangePage>(_onFilterRepositoriesChangePage);
    on<LoadMoreRepositories>(_onLoadMoreRepositories);
  }

  Future<void> _onFetchRepositories(
      FetchRepositories event, Emitter<RepositoryState> emit) async {
    emit(RepositoryLoading());

    try {
      final result = await fetchTrendingRepositories();
      endCursor = result['endCursor'];
      hasNextPage = result['hasNextPage'];

      emit(RepositoryLoaded(result['repositories'], result['repositories']));
    } catch (e) {
      emit(RepositoryError(e.toString()));
    }
  }

  void _onFilterRepositoriesByLanguage(
      FilterRepositoriesByLanguage event, Emitter<RepositoryState> emit) {
    if (state is RepositoryLoaded) {
      final initialRepositories =
          (state as RepositoryLoaded).initialRepositories;
      final filteredRepositories = event.language == 'All'
          ? initialRepositories
          : initialRepositories
              .where((repository) =>
                  repository.language.toLowerCase() ==
                  event.language.toLowerCase())
              .toList();
      emit(RepositoryLoaded(initialRepositories, filteredRepositories));
    }
  }

  Future<void> _onFilterRepositoriesChangePage(
      FilterRepositoriesChangePage event, Emitter<RepositoryState> emit) async {
    emit(RepositoryLoading());

    try {
      final result = await fetchTrendingRepositories(first: event.page);
      endCursor = result['endCursor'];
      hasNextPage = result['hasNextPage'];

      emit(RepositoryLoaded(result['repositories'], result['repositories']));
    } catch (e) {
      emit(RepositoryError(e.toString()));
    }
  }

  Future<void> _onLoadMoreRepositories(
      LoadMoreRepositories event, Emitter<RepositoryState> emit) async {
    if (state is RepositoryLoaded && hasNextPage) {
      try {
        final result = await fetchTrendingRepositories(after: endCursor);
        endCursor = result['endCursor'];
        hasNextPage = result['hasNextPage'];

        final currentRepositories =
            (state as RepositoryLoaded).initialRepositories;
        final newRepositories = result['repositories'];
        final updatedRepositories = List<Repository>.from(currentRepositories)
          ..addAll(newRepositories);

        emit(RepositoryLoaded(updatedRepositories, updatedRepositories));
      } catch (e) {
        emit(RepositoryError(e.toString()));
      }
    }
  }
}
