import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_list_notifier_test.mocks.dart';

void main() {
  late PopularTvBloc popularTvBloc;
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });

  blocTest<PopularTvBloc, PopularTvState>(
    "Should return [loading, loaded] when get data is succes",
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(testTvShowList));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(PopularTvEvent.started()),
    expect: () =>
        [PopularTvState.loading(), PopularTvState.loaded(testTvShowList)],
    verify: (bloc) => verify(mockGetPopularTv.execute()),
  );

  blocTest<PopularTvBloc, PopularTvState>(
    "Should return [loading, error] when get data is succes",
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(PopularTvEvent.started()),
    expect: () =>
        [PopularTvState.loading(), PopularTvState.error("terjadi kesalahan")],
    verify: (bloc) => verify(mockGetPopularTv.execute()),
  );

  blocTest<PopularTvBloc, PopularTvState>(
    "Should return [empty] when get data is empty",
    build: () {
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right([]));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(PopularTvEvent.started()),
    expect: () => [PopularTvState.loading(), PopularTvState.empty()],
    verify: (bloc) => verify(mockGetPopularTv.execute()),
  );
}
