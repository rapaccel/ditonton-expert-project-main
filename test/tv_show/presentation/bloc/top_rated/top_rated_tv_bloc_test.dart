import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_list_notifier_test.mocks.dart';

void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    "Should return [loading, loaded] when get data is succes",
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(testTvShowList));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(TopRatedTvEvent.fetch()),
    expect: () =>
        [TopRatedTvState.loading(), TopRatedTvState.loaded(testTvShowList)],
    verify: (bloc) => verify(mockGetTopRatedTv.execute()),
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    "Should return [loading, error] when get data is succes",
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(TopRatedTvEvent.fetch()),
    expect: () =>
        [TopRatedTvState.loading(), TopRatedTvState.error("terjadi kesalahan")],
    verify: (bloc) => verify(mockGetTopRatedTv.execute()),
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    "Should return [empty] when get data is empty",
    build: () {
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right([]));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(TopRatedTvEvent.fetch()),
    expect: () => [TopRatedTvState.loading(), TopRatedTvState.empty()],
    verify: (bloc) => verify(mockGetTopRatedTv.execute()),
  );
}
