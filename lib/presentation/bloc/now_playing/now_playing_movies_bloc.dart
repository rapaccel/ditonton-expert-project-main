import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';
part 'now_playing_movies_bloc.freezed.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  NowPlayingMoviesBloc(this.getNowPlayingMovies) : super(_Initial()) {
    on<NowPlayingMoviesEvent>((event, emit) async {
      emit(const NowPlayingMoviesState.loading());
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(NowPlayingMoviesState.error(failure.message)),
        (movies) => emit(NowPlayingMoviesState.loaded(movies)),
      );
    });
  }
}
