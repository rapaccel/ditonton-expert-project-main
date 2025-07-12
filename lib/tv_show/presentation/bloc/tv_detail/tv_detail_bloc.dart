import 'package:bloc/bloc.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show_detail.dart';
import 'package:ditonton/tv_show/domain/useCases/get_tv_detail.dart';
import 'package:ditonton/tv_show/domain/useCases/get_tv_recommendation.dart';
import 'package:ditonton/tv_show/domain/useCases/get_watch_list_status.dart';
import 'package:ditonton/tv_show/domain/useCases/remove_watch_list.dart';
import 'package:ditonton/tv_show/domain/useCases/save_watch_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';
part 'tv_detail_bloc.freezed.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvShowDetail;
  final SaveWatchListTv addToWatchlist;
  final RemoveWatchListTv removeFromWatchlist;
  final GetWatchListStatusTv getWatchlistStatus;
  final GetTvRecommendation getTvShowRecommendations;
  TvDetailBloc(
      this.getTvShowDetail,
      this.addToWatchlist,
      this.removeFromWatchlist,
      this.getWatchlistStatus,
      this.getTvShowRecommendations)
      : super(_Initial()) {
    on<TvDetailEvent>((event, emit) async {
      await event.when(
        fetch: (id) async {
          emit(const TvDetailState.loading());
          final detailResult = await getTvShowDetail.execute(id);
          final recommendationsResult =
              await getTvShowRecommendations.execute(id);
          final watchlistStatus = await getWatchlistStatus.execute(id);

          detailResult.fold(
            (failure) => emit(TvDetailState.error(failure.message)),
            (tvDetail) {
              recommendationsResult.fold(
                (failure) => emit(TvDetailState.error(failure.message)),
                (recommendations) {
                  emit(TvDetailState.loaded(
                    tvDetail: tvDetail,
                    recommendations: recommendations,
                    isAddedToWatchlist: watchlistStatus,
                  ));
                },
              );
            },
          );
        },
        addToWatchlist: (tv) async {
          final result = await addToWatchlist.execute(tv);
          result.fold(
            (failure) => emit(TvDetailState.error(failure.message)),
            (_) {
              final currentState = state;
              if (currentState is _Loaded) {
                emit(currentState.copyWith(isAddedToWatchlist: true));
              }
            },
          );
        },
        removeFromWatchlist: (tv) async {
          final result = await removeFromWatchlist.execute(tv);
          result.fold(
            (failure) => emit(TvDetailState.error(failure.message)),
            (_) {
              final currentState = state;
              if (currentState is _Loaded) {
                emit(currentState.copyWith(isAddedToWatchlist: false));
              }
            },
          );
        },
      );
    });
  }
}
