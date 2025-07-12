part of 'detail_movies_bloc.dart';

@freezed
class DetailMoviesEvent with _$DetailMoviesEvent {
  const factory DetailMoviesEvent.fetch(int id) = _Fetch;
  const factory DetailMoviesEvent.addToWatchlist(MovieDetail movie) =
      _AddToWatchlist;
  const factory DetailMoviesEvent.removeFromWatchlist(MovieDetail movie) =
      _RemoveFromWatchlist;
}
