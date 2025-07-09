import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_popular_tv.dart';
import 'package:ditonton/tv_show/presentation/provider/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTv = MockGetPopularTv();
    notifier = PopularTvNotifier(getPopularTv: mockGetPopularTv)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvShow = TvShow(
    name: 'name',
    runtime: 1,
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvShowList = <TvShow>[tTvShow];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTv.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    notifier.fetchPopular();
    // assert
    expect(notifier.popularTvShowsState, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTv.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    await notifier.fetchPopular();
    // assert
    expect(notifier.popularTvShowsState, RequestState.Loaded);
    expect(notifier.popularTvShows, tTvShowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTv.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopular();
    // assert
    expect(notifier.popularTvShowsState, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
