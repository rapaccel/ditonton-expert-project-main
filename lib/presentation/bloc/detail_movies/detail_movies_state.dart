part of 'detail_movies_bloc.dart';

@freezed
class DetailMoviesState with _$DetailMoviesState {
  const factory DetailMoviesState.initial() = _Initial;
  const factory DetailMoviesState.loading() = _Loading;
  const factory DetailMoviesState.loaded({
    required MovieDetail movies,
    required List<Movie> recommendations,
    required bool isAddedToWatchlist,
  }) = _Loaded;
  const factory DetailMoviesState.error(String message) = _Error;
  const factory DetailMoviesState.empty() = _Empty;
}
