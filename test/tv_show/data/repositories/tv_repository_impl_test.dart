import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/data/models/tv_detail_model.dart';
import 'package:ditonton/tv_show/data/models/tv_model.dart';
import 'package:ditonton/tv_show/data/repositories/tv_repositories_impl.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoriesImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockDatabaseHelper mockDatabaseHelper;
  late MovieLocalDataSource dataSource;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    dataSource = MovieLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
    repository = TvRepositoriesImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTvShowModel = TvModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    originalLanguage: 'en',
    runtime: 12,
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final testTvShowModel = [tTvShowModel];

  final tTvShow = TvShow(
    name: "Spider-Man",
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    runtime: 12,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final testTvFromCache = TvShow.watchlist(
    id: 557,
    name: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  );

  final testTvCache = MovieTable(
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    title: 'Spider-Man',
  );
  final testTvCacheMap = {
    'id': 557,
    'overview':
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    'name': 'Spider-Man',
    'runtime': 12,
    'voteAverage': 7.2,
    'voteCount': 13507,
  };
  final tTvList = <TvShow>[tTvShow];

  group('Now Playing tv', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getOnTheAirTvShows())
          .thenAnswer((_) async => []);
      // act
      await repository.getOnTheAirTvShows();
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    test('should return list of tv from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheMovies('now playing'))
          .thenAnswer((_) async => [testTvCacheMap]);
      when(mockLocalDataSource.getCachedNowPlayingMovies())
          .thenAnswer((_) async => [testTvCache]);
      // act
      final result = await mockLocalDataSource.getCachedNowPlayingMovies();
      final resultList = result.map((e) => e.toTvShowEntity()).toList();
      // assert
      expect(resultList, [testTvFromCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      when(mockLocalDataSource.getCachedNowPlayingMovies())
          .thenThrow(CacheException('No Cache Found'));

      expect(
        () async => await mockLocalDataSource.getCachedNowPlayingMovies(),
        throwsA(isA<CacheException>()),
      );
    });
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearCache('now playing'))
          .thenAnswer((_) async => 1);
      when(mockDatabaseHelper.insertCacheTransaction(any, any))
          .thenAnswer((_) async => 1);
      // act
      await mockLocalDataSource.cacheNowPlayingMovies([testTvCache]);
      // assert
    });
    group('cache now playing tv', () {
      test('should call database helper to save data', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        // arrange
        when(mockDatabaseHelper.clearCache('now playing'))
            .thenAnswer((_) async => 1);
        // act
        await dataSource.cacheNowPlayingMovies([testTvCache]);
        // assert
        verify(mockDatabaseHelper.clearCache('now playing'));
        verify(mockDatabaseHelper
            .insertCacheTransaction([testTvCache], 'now playing'));
      });
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        test(
            'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getOnTheAirTvShows())
              .thenAnswer((_) async => testTvShowModel);
          // act
          final result = await repository.getOnTheAirTvShows();
          // assert
          verify(mockRemoteDataSource.getOnTheAirTvShows());
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

        test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getOnTheAirTvShows())
              .thenThrow(ServerException());
          // act
          final result = await repository.getOnTheAirTvShows();
          // assert
          verify(mockRemoteDataSource.getOnTheAirTvShows());
          expect(result,
              equals(Left(ServerFailure('Failed to fetch data from server'))));
        });
      });
    });
    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return connection failure when the device is not connected to internet',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(mockRemoteDataSource.getOnTheAirTvShows())
              .thenThrow(SocketException('Failed to connect to the network'));

          // act
          final result = await repository.getOnTheAirTvShows();

          // assert
          verify(mockRemoteDataSource.getOnTheAirTvShows());
          expect(
              result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        },
      );
    });
  });

  group('Popular tv', () {
    test('should return tv list when call to data source is success', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvShows())
          .thenAnswer((_) async => testTvShowModel);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      final result = await repository.getPopularTvShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      final expectedList = testTvShowModel.map((e) => e.toEntity()).toList();
      expect(resultList, expectedList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getPopularTvShows())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvShows();
      // assert
      expect(result, Left(ServerFailure('Failed to fetch data from server')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvShows())
          .thenThrow(SocketException('No internet connection'));
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      // act
      final result = await repository.getPopularTvShows();
      // assert
      expect(result, Left(ConnectionFailure('No internet connection')));
    });
  });

  group('Top Rated tv', () {
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemoteDataSource.getTopRatedTvShows())
          .thenAnswer((_) async => testTvShowModel);
      // act
      final result = await repository.getTopRatedTvShows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvShows())
          .thenThrow(ServerException());
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      final result = await repository.getTopRatedTvShows();
      // assert
      expect(result, Left(ServerFailure('Failed to fetch data from server')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvShows())
          .thenThrow(SocketException('No internet connection'));
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      // act
      final result = await repository.getTopRatedTvShows();
      // assert
      expect(result, Left(ConnectionFailure('No internet connection')));
    });
  });

  group('Get tv Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      name: 'tvName',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return tv data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenAnswer((_) async => tTvResponse);

      final expected = tTvResponse.toEntity();

      // act
      final result = await repository.getTvShowDetail(tId);

      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result, equals(Right(expected)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result,
          equals(Left(ServerFailure('Failed to fetch data from server'))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenThrow(SocketException('No internet connection'));
      // act
      final result = await repository.getTvShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get tv Recommendations', () {
    final tTvList = <TvModel>[];
    final tId = 1;

    test('should return data (tv list) when the call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendations(tId))
          .thenAnswer((_) async => tTvList);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      final result = await repository.getTvRecommendation(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendations(tId))
          .thenThrow(ServerException());
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      final result = await repository.getTvRecommendation(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTvShowRecommendations(tId));
      expect(result,
          equals(Left(ServerFailure('Failed to fetch data from server'))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendations(tId))
          .thenThrow(SocketException('No internet connection'));
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      final result = await repository.getTvRecommendation(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach TvShow', () {
    final tQuery = 'breaking bad';

    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShows(tQuery))
          .thenAnswer((_) async => testTvShowModel);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      final result = await repository.searchTvShows(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShows(tQuery))
          .thenThrow(ServerException());
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      final result = await repository.searchTvShows(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvShows(tQuery))
          .thenThrow(SocketException('No internet connection'));
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.searchTvShows(tQuery);
      // assert
      expect(result, Left(ConnectionFailure('No internet connection')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      final testMovieTable = MovieTable.fromTvEntity(testTvDetail);
      // arrange
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      final testMovieTable = MovieTable.fromTvEntity(testTvDetail);
      // arrange
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      final testMovieTable = MovieTable.fromTvEntity(testTvDetail);
      // arrange
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      final testMovieTable = MovieTable.fromTvEntity(testTvDetail);

      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));

      final result = await repository.removeWatchlist(testTvDetail);

      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tvShow', () {
    test('should return list of tvShow', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);
      // act
      final result = await repository.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      final testWatchlistMovie = testMovieTable.toTvShowEntity();
      expect(resultList, [testWatchlistMovie]);
    });
  });
}
