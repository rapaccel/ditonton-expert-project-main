import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_list_notifier_test.mocks.dart';

void main() {
  late TvListBloc tvListBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetOnAirTv mockGetOnAirTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetOnAirTv = MockGetOnAirTv();
    tvListBloc = TvListBloc(
      mockGetOnAirTv,
      mockGetPopularTv,
      mockGetTopRatedTv,
    );
  });

  blocTest<TvListBloc, TvListState>(
      "Should return [loading, loaded] when get data is succes",
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(testTvShowList));
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(testTvShowList));
        when(mockGetOnAirTv.execute())
            .thenAnswer((_) async => Right(testTvShowList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(TvListEvent.fetch()),
      expect: () => [
            TvListState.loading(),
            TvListState.loaded(
                onAir: testTvShowList,
                popular: testTvShowList,
                topRated: testTvShowList)
          ],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
        verify(mockGetPopularTv.execute());
        verify(mockGetOnAirTv.execute());
      });

  blocTest<TvListBloc, TvListState>(
    "Should return [loading, error] when get data all failed",
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      when(mockGetOnAirTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(TvListEvent.fetch()),
    expect: () => [
      TvListState.loading(),
      TvListState.loaded(onAir: [], popular: [], topRated: [])
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
      verify(mockGetPopularTv.execute());
      verify(mockGetOnAirTv.execute());
    },
  );

  blocTest<TvListBloc, TvListState>(
    "Should return [empty] when get data is empty",
    build: () {
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right([]));
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right([]));
      when(mockGetOnAirTv.execute()).thenAnswer((_) async => Right([]));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(TvListEvent.fetch()),
    expect: () => [
      TvListState.loading(),
      TvListState.loaded(onAir: [], popular: [], topRated: [])
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
      verify(mockGetPopularTv.execute());
      verify(mockGetOnAirTv.execute());
    },
  );
}
