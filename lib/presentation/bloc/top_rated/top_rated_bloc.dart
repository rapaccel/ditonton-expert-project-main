import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';
part 'top_rated_bloc.freezed.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  final GetTopRatedMovies getTopRatedMovies;
  TopRatedBloc(this.getTopRatedMovies) : super(_Initial()) {
    on<TopRatedEvent>((event, emit) async {
      final result = await getTopRatedMovies.execute();
      emit(TopRatedState.loading());
      result.fold(
        (failure) => emit(TopRatedState.error(failure.message)),
        (movies) => emit(TopRatedState.loaded(movies)),
      );
    });
  }
}
