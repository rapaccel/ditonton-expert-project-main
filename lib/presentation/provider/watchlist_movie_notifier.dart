import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:flutter/foundation.dart';

class WatchlistMovieNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTvShows = <TvShow>[];
  List<TvShow> get watchlistTvShows => _watchlistTvShows;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistMovieNotifier({required this.getWatchlistMovies});

  final GetWatchlistMovies getWatchlistMovies;

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistMovies = moviesData
            .where((m) => m.type == "movie")
            .map((m) => m.toMovie())
            .toList();
        _watchlistTvShows = moviesData
            .where((m) => m.type == "tv_show")
            .map((m) => m.toTvShow())
            .toList();
        for (final m in moviesData) {
          print('Fetched movie: ${m.title}, type: ${m.type}');
        }
        _watchlistState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
