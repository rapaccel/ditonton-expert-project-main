import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/presentation/bloc/search_tv/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../provider/search_tv_notifier_test.mocks.dart';

void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTvShow mockSearchTvShow;

  setUp(() {
    mockSearchTvShow = MockSearchTvShow();
    searchTvBloc = SearchTvBloc(mockSearchTvShow);
  });

  blocTest<SearchTvBloc, SearchTvState>(
    "Should return [loading, loaded] when get data is succes",
    build: () {
      when(mockSearchTvShow.execute("test"))
          .thenAnswer((_) async => Right(testTvShowList));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(SearchTvEvent.onFetched("test")),
    wait: const Duration(milliseconds: 500),
    expect: () =>
        [SearchTvState.loading(), SearchTvState.loaded(testTvShowList)],
    verify: (bloc) => verify(mockSearchTvShow.execute("test")),
  );

  blocTest<SearchTvBloc, SearchTvState>(
    "Should return [loading, error] when get data is succes",
    build: () {
      when(mockSearchTvShow.execute("test"))
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      return searchTvBloc;
    },
    wait: const Duration(milliseconds: 500),
    act: (bloc) => bloc.add(SearchTvEvent.onFetched("test")),
    expect: () =>
        [SearchTvState.loading(), SearchTvState.error("terjadi kesalahan")],
    verify: (bloc) => verify(mockSearchTvShow.execute("test")),
  );

  blocTest<SearchTvBloc, SearchTvState>(
    "Should return [empty] when get data is empty",
    build: () {
      when(mockSearchTvShow.execute("test")).thenAnswer((_) async => Right([]));
      return searchTvBloc;
    },
    wait: const Duration(milliseconds: 500),
    act: (bloc) => bloc.add(SearchTvEvent.onFetched("test")),
    expect: () => [SearchTvState.loading(), SearchTvState.empty()],
    verify: (bloc) => verify(mockSearchTvShow.execute("test")),
  );
}
