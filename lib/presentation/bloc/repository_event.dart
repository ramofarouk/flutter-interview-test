import 'package:equatable/equatable.dart';

abstract class RepositoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRepositories extends RepositoryEvent {}

class FilterRepositoriesByLanguage extends RepositoryEvent {
  final String language;

  FilterRepositoriesByLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

class FilterRepositoriesChangePage extends RepositoryEvent {
  final int page;

  FilterRepositoriesChangePage(this.page);

  @override
  List<Object?> get props => [page];
}

class LoadMoreRepositories extends RepositoryEvent {}
