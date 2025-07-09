import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_on_air_tv.dart';
import 'package:flutter/cupertino.dart';

class OnAirTvNotifier extends ChangeNotifier {
  final GetOnAirTv getOnAirTv;

  OnAirTvNotifier({required this.getOnAirTv});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _movies = [];
  List<TvShow> get movies => _movies;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedMovies() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTv.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (moviesData) {
        _movies = moviesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
