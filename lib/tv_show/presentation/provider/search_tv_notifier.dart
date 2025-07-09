import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/search_tv_show.dart';
import 'package:flutter/cupertino.dart';

class SearchTvNotifier extends ChangeNotifier {
  final SearchTvShow searchTvShow;

  SearchTvNotifier({required this.searchTvShow});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _searchResult = [];
  List<TvShow> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvShow.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        print("search result : $data");
        notifyListeners();
      },
    );
  }
}
