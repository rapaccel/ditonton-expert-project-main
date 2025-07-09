import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_on_air_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_popular_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_top_rated_tv.dart';
import 'package:flutter/cupertino.dart';

class TvListNotifier extends ChangeNotifier {
  var _nowAiringTvShows = <TvShow>[];
  List<TvShow> get nowAiringTvShows => _nowAiringTvShows;

  RequestState _nowAiringState = RequestState.Empty;
  RequestState get nowAiringState => _nowAiringState;

  var _popularTvShows = <TvShow>[];
  List<TvShow> get popularTvShows => _popularTvShows;

  RequestState _popularTvShowsState = RequestState.Empty;
  RequestState get popularTvShowsState => _popularTvShowsState;

  var _topRatedTvShows = <TvShow>[];
  List<TvShow> get topRatedTvShows => _topRatedTvShows;

  RequestState _topRatedTvShowsState = RequestState.Empty;
  RequestState get topRatedTvShowsState => _topRatedTvShowsState;

  String _message = '';
  String get message => _message;

  TvListNotifier({
    required this.getNowAiringTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  });

  final GetOnAirTv getNowAiringTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  Future<void> fetchNowAiring() async {
    _nowAiringState = RequestState.Loading;
    notifyListeners();

    final result = await getNowAiringTv.execute();
    result.fold(
      (failure) {
        _nowAiringState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _nowAiringState = RequestState.Loaded;
        _nowAiringTvShows = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopular() async {
    _popularTvShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold(
      (failure) {
        _popularTvShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _popularTvShowsState = RequestState.Loaded;
        _popularTvShows = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRated() async {
    _topRatedTvShowsState = RequestState.Loading;
    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        _topRatedTvShowsState = RequestState.Error;
        _message = failure.message;
      },
      (tvData) {
        _topRatedTvShowsState = RequestState.Loaded;
        _topRatedTvShows = tvData;
      },
    );
    notifyListeners();
  }
}
