import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_movies_event.dart';
part 'detail_movies_state.dart';
part 'detail_movies_bloc.freezed.dart';

class DetailMoviesBloc extends Bloc<DetailMoviesEvent, DetailMoviesState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  DetailMoviesBloc(this.getMovieDetail, this.getMovieRecommendations,
      this.getWatchListStatus, this.removeWatchlist, this.saveWatchlist)
      : super(_Initial()) {
    on<DetailMoviesEvent>((event, emit) async {
      await event.when(fetch: (id) async {
        emit(const DetailMoviesState.loading());

        final detailResult = await getMovieDetail.execute(id);
        final recommendationResult = await getMovieRecommendations.execute(id);

        await detailResult.fold(
          (failure) async {
            emit(DetailMoviesState.error(failure.message));
          },
          (movie) async {
            final recommendations = recommendationResult.getOrElse(() => []);

            final watchlistStatus = await getWatchListStatus.execute(id);

            emit(DetailMoviesState.loaded(
              movies: movie,
              recommendations: recommendations,
              isAddedToWatchlist: watchlistStatus,
            ));
          },
        );
      }, addToWatchlist: (movie) async {
        final result = await saveWatchlist.execute(movie);
        final isAdded = await getWatchListStatus.execute(movie.id);
        result.fold(
          (failure) => emit(DetailMoviesState.error(failure.message)),
          (_) {
            final currentState = state;
            if (currentState is _Loaded) {
              emit(currentState.copyWith(isAddedToWatchlist: isAdded));
            }
          },
        );
      }, removeFromWatchlist: (movie) async {
        final result = await removeWatchlist.execute(movie);
        final isAdded = await getWatchListStatus.execute(movie.id);
        result.fold(
          (failure) => emit(DetailMoviesState.error(failure.message)),
          (_) {
            final currentState = state;
            if (currentState is _Loaded) {
              emit(currentState.copyWith(isAddedToWatchlist: isAdded));
            }
          },
        );
      });
    });
  }
}
