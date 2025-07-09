import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_on_air_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_popular_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_top_rated_tv.dart';
import 'package:ditonton/tv_show/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetOnAirTv, GetPopularTv, GetTopRatedTv])
void main() {
  late TvListNotifier provider;
  late MockGetOnAirTv mockGetOnAirTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnAirTv = MockGetOnAirTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TvListNotifier(
      getNowAiringTv: mockGetOnAirTv,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    )..addListener(() {
        listenerCallCount += 1;
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

  group('now playing movies', () {
    test('initialState should be Empty', () {
      expect(provider.nowAiringState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetOnAirTv.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchNowAiring();
      // assert
      verify(mockGetOnAirTv.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetOnAirTv.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchNowAiring();
      // assert
      expect(provider.nowAiringState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetOnAirTv.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchNowAiring();
      // assert
      expect(provider.nowAiringState, RequestState.Loaded);
      expect(provider.nowAiringTvShows, tTvShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnAirTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowAiring();
      // assert
      expect(provider.nowAiringState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchPopular();
      // assert
      expect(provider.popularTvShowsState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchPopular();
      // assert
      expect(provider.popularTvShowsState, RequestState.Loaded);
      expect(provider.popularTvShows, tTvShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopular();
      // assert
      expect(provider.popularTvShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tvShows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchTopRated();
      // assert
      expect(provider.topRatedTvShowsState, RequestState.Loading);
    });

    test('should change tvShows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchTopRated();
      // assert
      expect(provider.topRatedTvShowsState, RequestState.Loaded);
      expect(provider.topRatedTvShows, tTvShowList);
      expect(listenerCallCount, 1);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRated();
      // assert
      expect(provider.topRatedTvShowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 1);
    });
  });
}
