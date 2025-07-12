part of 'list_movies_bloc.dart';

@freezed
class ListMoviesState with _$ListMoviesState {
  const factory ListMoviesState({
    @Default([]) List<Movie> nowPlaying,
    @Default([]) List<Movie> popular,
    @Default([]) List<Movie> topRated,
    @Default(false) bool isLoading,
    String? error,
  }) = _ListMoviesState;
}
