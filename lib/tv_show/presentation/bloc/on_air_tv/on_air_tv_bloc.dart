import 'package:bloc/bloc.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_on_air_tv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_air_tv_event.dart';
part 'on_air_tv_state.dart';
part 'on_air_tv_bloc.freezed.dart';

class OnAirTvBloc extends Bloc<OnAirTvEvent, OnAirTvState> {
  final GetOnAirTv getOnAirTv;
  OnAirTvBloc(this.getOnAirTv) : super(const OnAirTvState.loading()) {
    on<OnAirTvEvent>((event, emit) async {
      await event.when(
        started: () async {
          emit(const OnAirTvState.loading());

          final result = await getOnAirTv.execute();

          result.fold(
            (failure) => emit(OnAirTvState.error(failure.message)),
            (tvShows) => tvShows.isEmpty
                ? emit(const OnAirTvState.empty())
                : emit(OnAirTvState.loaded(tvShows)),
          );
        },
      );
    });
  }
}
