import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'watch_list_event.dart';
part 'watch_list_state.dart';
part 'watch_list_bloc.freezed.dart';

class WatchListBloc extends Bloc<WatchListEvent, WatchListState> {
  final GetWatchlistMovies getWatchlistMovies;
  WatchListBloc(this.getWatchlistMovies) : super(_Initial()) {
    on<WatchListEvent>((event, emit) async {
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(WatchListState.error(failure.message)),
        (moviesData) {
          final movies = moviesData
              .where((m) => m.type == "movie")
              .map((m) => m.toMovie())
              .toList();
          final tvShows = moviesData
              .where((m) => m.type == "tv_show")
              .map((m) => m.toTvShow())
              .toList();
          if (movies.isEmpty && tvShows.isEmpty) {
            emit(const WatchListState.empty());
          } else {
            emit(WatchListState.loaded(movies: movies, tvShows: tvShows));
          }
        },
      );
    });
  }
}
