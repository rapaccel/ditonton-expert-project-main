part of 'popular_movies_bloc.dart';

@freezed
class PopularMoviesState with _$PopularMoviesState {
  const factory PopularMoviesState.loading() = _Loading;
  const factory PopularMoviesState.loaded(List<Movie> movies) = _Loaded;
  const factory PopularMoviesState.error(String message) = _Error;
}
