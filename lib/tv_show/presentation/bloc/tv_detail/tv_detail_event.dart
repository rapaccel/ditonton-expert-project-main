part of 'tv_detail_bloc.dart';

@freezed
class TvDetailEvent with _$TvDetailEvent {
  const factory TvDetailEvent.fetch(int id) = _Fetch;
  const factory TvDetailEvent.addToWatchlist(TvShowDetail tv) = _AddToWatchlist;
  const factory TvDetailEvent.removeFromWatchlist(TvShowDetail tv) =
      _RemoveFromWatchlist;
}
