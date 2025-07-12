import 'package:bloc/bloc.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_popular_tv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';
part 'popular_tv_bloc.freezed.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv getPopularTv;
  PopularTvBloc(this.getPopularTv) : super(const PopularTvState.loading()) {
    on<PopularTvEvent>((event, emit) async {
      await event.when(
        started: () async {
          emit(const PopularTvState.loading());

          final result = await getPopularTv.execute();

          result.fold(
            (failure) => emit(PopularTvState.error(failure.message)),
            (tvShows) => tvShows.isEmpty
                ? emit(const PopularTvState.empty())
                : emit(PopularTvState.loaded(tvShows)),
          );
        },
      );
    });
  }
}
