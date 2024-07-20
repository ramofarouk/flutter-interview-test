import 'package:equatable/equatable.dart';
import 'package:flutter_interview/core/entities/repository.dart';

abstract class RepositoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RepositoryInitial extends RepositoryState {}

class RepositoryLoading extends RepositoryState {}

class RepositoryLoaded extends RepositoryState {
   final List<Repository> initialRepositories;
  final List<Repository> filteredRepositories;

 
  RepositoryLoaded(this.initialRepositories, this.filteredRepositories);

  @override
  List<Object?> get props => [initialRepositories, filteredRepositories];
}

class RepositoryError extends RepositoryState {
  final String message;

  RepositoryError(this.message);

  @override
  List<Object?> get props => [message];
}
