import 'package:bloc/bloc.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_on_air_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_popular_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_top_rated_tv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';
part 'tv_list_bloc.freezed.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetOnAirTv getOnAirTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;
  TvListBloc(this.getOnAirTv, this.getPopularTv, this.getTopRatedTv)
      : super(const TvListState.loading()) {
    on<TvListEvent>((event, emit) async {
      await event.when(
        fetch: () async {
          emit(const TvListState.loading());

          final onAirResult = await getOnAirTv.execute();
          final popularResult = await getPopularTv.execute();
          final topRatedResult = await getTopRatedTv.execute();

          emit(
            TvListState.loaded(
              onAir: onAirResult.getOrElse(() => []),
              popular: popularResult.getOrElse(() => []),
              topRated: topRatedResult.getOrElse(() => []),
            ),
          );
        },
      );
    });
  }
}
