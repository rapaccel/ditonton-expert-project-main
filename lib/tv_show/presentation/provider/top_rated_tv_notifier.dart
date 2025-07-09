import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_top_rated_tv.dart';
import 'package:flutter/cupertino.dart';

class TopRatedTvNotifier extends ChangeNotifier {
  var _topRatedTvShows = <TvShow>[];
  List<TvShow> get topRatedTvShows => _topRatedTvShows;

  RequestState _topRatedTvShowsState = RequestState.Empty;
  RequestState get topRatedTvShowsState => _topRatedTvShowsState;

  String _message = '';
  String get message => _message;

  TopRatedTvNotifier({
    required this.getTopRatedTv,
  });

  final GetTopRatedTv getTopRatedTv;

  Future<void> fetchTopRated() async {
    _topRatedTvShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        _topRatedTvShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topRatedTvShowsState = RequestState.Loaded;
        _topRatedTvShows = tvData;
        notifyListeners();
      },
    );
  }
}
