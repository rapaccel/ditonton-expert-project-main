import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_movies_event.dart';
part 'list_movies_state.dart';
part 'list_movies_bloc.freezed.dart';

class ListMoviesBloc extends Bloc<ListMoviesEvent, ListMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  ListMoviesBloc(
      this.getNowPlayingMovies, this.getPopularMovies, this.getTopRatedMovies)
      : super(const ListMoviesState()) {
    on<ListMoviesEvent>((event, emit) async {
      await event.when(
        fetchAll: () async {
          emit(state.copyWith(isLoading: true));
          try {
            final nowPlayingResult = await getNowPlayingMovies.execute();
            final popularResult = await getPopularMovies.execute();
            final topRatedResult = await getTopRatedMovies.execute();

            emit(state.copyWith(
              nowPlaying: nowPlayingResult.getOrElse(() => []),
              popular: popularResult.getOrElse(() => []),
              topRated: topRatedResult.getOrElse(() => []),
              isLoading: false,
            ));
          } catch (e) {
            emit(state.copyWith(
              isLoading: false,
              error: e.toString(),
            ));
          }
        },
      );
    });
  }
}
