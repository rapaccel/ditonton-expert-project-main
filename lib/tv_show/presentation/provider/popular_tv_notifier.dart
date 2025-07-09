import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_popular_tv.dart';
import 'package:flutter/cupertino.dart';

class PopularTvNotifier extends ChangeNotifier {
  var _popularTvShows = <TvShow>[];
  List<TvShow> get popularTvShows => _popularTvShows;

  RequestState _popularTvShowsState = RequestState.Empty;
  RequestState get popularTvShowsState => _popularTvShowsState;

  String _message = '';
  String get message => _message;

  PopularTvNotifier({
    required this.getPopularTv,
  });

  final GetPopularTv getPopularTv;

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
        print("data popular $tvData");
      },
    );
  }
}
