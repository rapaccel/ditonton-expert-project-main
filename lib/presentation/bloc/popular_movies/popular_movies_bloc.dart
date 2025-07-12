import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';
part 'popular_movies_bloc.freezed.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;
  PopularMoviesBloc(this.getPopularMovies)
      : super(const PopularMoviesState.loading()) {
    on<PopularMoviesEvent>((event, emit) async {
      await event.when(
        fetch: () async {
          emit(const PopularMoviesState.loading());
          final result = await getPopularMovies.execute();
          result.fold(
            (failure) => emit(PopularMoviesState.error(failure.message)),
            (movies) => emit(PopularMoviesState.loaded(movies)),
          );
        },
      );
    });
  }
}
