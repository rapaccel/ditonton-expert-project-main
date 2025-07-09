import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show_detail.dart';
import 'package:ditonton/tv_show/domain/useCases/get_tv_detail.dart';
import 'package:ditonton/tv_show/domain/useCases/get_tv_recommendation.dart';
import 'package:ditonton/tv_show/domain/useCases/get_watch_list_status.dart';
import 'package:ditonton/tv_show/domain/useCases/remove_watch_list.dart';
import 'package:ditonton/tv_show/domain/useCases/save_watch_list.dart';
import 'package:flutter/cupertino.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvShowDetail;
  final GetTvRecommendation getTvShowRecommendations;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchListTv saveWatchlist;
  final RemoveWatchListTv removeWatchlist;

  TvDetailNotifier({
    required this.getTvShowDetail,
    required this.getTvShowRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  // TV show detail and state variables
  late TvShowDetail _tvShow;
  TvShowDetail get tvShow => _tvShow;

  RequestState _tvShowState = RequestState.Empty;
  RequestState get tvShowState => _tvShowState;
  // Dependencies for fetching TV show details, recommendations, and watchlist status
  List<TvShow> _tvShowRecommendations = [];
  List<TvShow> get tvShowRecommendations => _tvShowRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  // Method to fetch TV show details
  Future<void> fetchTvShowDetail(int id) async {
    _tvShowState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvShowDetail.execute(id);
    final recommendationResult = await getTvShowRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvShowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationState = RequestState.Loading;
        _tvShow = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvs) {
            _recommendationState = RequestState.Loaded;
            _tvShowRecommendations = tvs;
          },
        );
        _tvShowState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  // Method to check if the TV show is added to watchlist
  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvShowDetail tvShow) async {
    final result = await saveWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> removeFromWatchlist(TvShowDetail movie) async {
    final result = await removeWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }
}
