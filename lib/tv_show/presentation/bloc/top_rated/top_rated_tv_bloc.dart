import 'package:bloc/bloc.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_top_rated_tv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';
part 'top_rated_tv_bloc.freezed.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv getTopRatedTv;
  TopRatedTvBloc(this.getTopRatedTv) : super(const TopRatedTvState.loading()) {
    on<TopRatedTvEvent>((event, emit) async {
      await event.when(
        fetch: () async {
          emit(const TopRatedTvState.loading());

          final result = await getTopRatedTv.execute();

          result.fold(
            (failure) => emit(TopRatedTvState.error(failure.message)),
            (tvShows) => tvShows.isEmpty
                ? emit(const TopRatedTvState.empty())
                : emit(TopRatedTvState.loaded(tvShows)),
          );
        },
      );
    });
  }
}
