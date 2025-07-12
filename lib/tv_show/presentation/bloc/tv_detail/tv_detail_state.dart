part of 'tv_detail_bloc.dart';

@freezed
class TvDetailState with _$TvDetailState {
  const factory TvDetailState.initial() = _Initial;
  const factory TvDetailState.loading() = _Loading;
  const factory TvDetailState.loaded({
    required TvShowDetail tvDetail,
    required List<TvShow> recommendations,
    required bool isAddedToWatchlist,
  }) = _Loaded;
  const factory TvDetailState.error(String message) = _Error;
  const factory TvDetailState.empty() = _Empty;
}
