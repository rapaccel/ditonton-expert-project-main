import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/presentation/bloc/on_air_tv/on_air_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_list_notifier_test.mocks.dart';

void main() {
  late OnAirTvBloc onAirTvBloc;
  late MockGetOnAirTv mockGetOnAirTv;

  setUp(() {
    mockGetOnAirTv = MockGetOnAirTv();
    onAirTvBloc = OnAirTvBloc(mockGetOnAirTv);
  });

  blocTest<OnAirTvBloc, OnAirTvState>(
    "Should return [loading, loaded] when get data is succes",
    build: () {
      when(mockGetOnAirTv.execute())
          .thenAnswer((_) async => Right(testTvShowList));
      return onAirTvBloc;
    },
    act: (bloc) => bloc.add(OnAirTvEvent.started()),
    expect: () => [OnAirTvState.loading(), OnAirTvState.loaded(testTvShowList)],
    verify: (bloc) => verify(mockGetOnAirTv.execute()),
  );

  blocTest<OnAirTvBloc, OnAirTvState>(
    "Should return [loading, error] when get data is succes",
    build: () {
      when(mockGetOnAirTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      return onAirTvBloc;
    },
    act: (bloc) => bloc.add(OnAirTvEvent.started()),
    expect: () =>
        [OnAirTvState.loading(), OnAirTvState.error("terjadi kesalahan")],
    verify: (bloc) => verify(mockGetOnAirTv.execute()),
  );

  blocTest<OnAirTvBloc, OnAirTvState>(
    "Should return [loading, empty] when get data is empty",
    build: () {
      when(mockGetOnAirTv.execute()).thenAnswer((_) async => Right([]));
      return onAirTvBloc;
    },
    act: (bloc) => bloc.add(OnAirTvEvent.started()),
    expect: () => [OnAirTvState.loading(), OnAirTvState.empty()],
    verify: (bloc) => verify(mockGetOnAirTv.execute()),
  );
}
