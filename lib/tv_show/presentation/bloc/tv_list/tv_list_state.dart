part of 'tv_list_bloc.dart';

@freezed
class TvListState with _$TvListState {
  const factory TvListState.loading() = _Loading;
  const factory TvListState.loaded({
    required List<TvShow> onAir,
    required List<TvShow> popular,
    required List<TvShow> topRated,
  }) = _Loaded;
  const factory TvListState.error(String message) = _Error;
  const factory TvListState.empty() = _Empty;
}
