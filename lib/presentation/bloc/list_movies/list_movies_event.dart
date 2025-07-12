part of 'list_movies_bloc.dart';

@freezed
class ListMoviesEvent with _$ListMoviesEvent {
  const factory ListMoviesEvent.fetchAll() = _FetchAll;
}
