import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/detail_movies/detail_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/movie_detail_notifier_test.mocks.dart';

void main() {
  late DetailMoviesBloc detailMoviesBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockSaveWatchlist = MockSaveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    detailMoviesBloc = DetailMoviesBloc(
        mockGetMovieDetail,
        mockGetMovieRecommendations,
        mockGetWatchListStatus,
        mockRemoveWatchlist,
        mockSaveWatchlist);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  blocTest<DetailMoviesBloc, DetailMoviesState>(
    "Should emit [loading, loaded] when fetch movie detail is successful",
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => const Right([]));
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
      return detailMoviesBloc;
    },
    act: (bloc) => bloc.add(const DetailMoviesEvent.fetch(1)),
    expect: () => [
      const DetailMoviesState.loading(),
      DetailMoviesState.loaded(
        movies: testMovieDetail,
        recommendations: const [],
        isAddedToWatchlist: false,
      ),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(1));
      verify(mockGetMovieRecommendations.execute(1));
      verify(mockGetWatchListStatus.execute(1));
    },
  );

  blocTest<DetailMoviesBloc, DetailMoviesState>(
    "Should emit [loading, loaded] when fetch movie detail and recommendations is successful",
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
      return detailMoviesBloc;
    },
    act: (bloc) => bloc.add(const DetailMoviesEvent.fetch(1)),
    expect: () => [
      const DetailMoviesState.loading(),
      DetailMoviesState.loaded(
        movies: testMovieDetail,
        recommendations: tMovieList,
        isAddedToWatchlist: false,
      ),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(1));
      verify(mockGetMovieRecommendations.execute(1));
      verify(mockGetWatchListStatus.execute(1));
    },
  );

  blocTest<DetailMoviesBloc, DetailMoviesState>(
    "Should emit [loading, error] when fetch movie detail and recommendations is failed",
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure("terjadi kesalahan")));
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Left(ServerFailure("terjadi kesalahan")));
      return detailMoviesBloc;
    },
    act: (bloc) => bloc.add(const DetailMoviesEvent.fetch(1)),
    expect: () => [
      const DetailMoviesState.loading(),
      DetailMoviesState.error("terjadi kesalahan"),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(1));
      verify(mockGetMovieRecommendations.execute(1));
    },
  );

  blocTest<DetailMoviesBloc, DetailMoviesState>(
    "Should emit updated state when addToWatchlist is successful",
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right("Success"));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      return detailMoviesBloc
        ..emit(DetailMoviesState.loaded(
          movies: testMovieDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ));
    },
    act: (bloc) => bloc.add(DetailMoviesEvent.addToWatchlist(testMovieDetail)),
    expect: () => [
      DetailMoviesState.loaded(
        movies: testMovieDetail,
        recommendations: [],
        isAddedToWatchlist: true,
      ),
    ],
    verify: (_) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<DetailMoviesBloc, DetailMoviesState>(
    "Should emit error when addToWatchlist fails",
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure("Gagal menambahkan")));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return detailMoviesBloc;
    },
    act: (bloc) => bloc.add(DetailMoviesEvent.addToWatchlist(testMovieDetail)),
    expect: () => [
      DetailMoviesState.error("Gagal menambahkan"),
    ],
    verify: (_) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<DetailMoviesBloc, DetailMoviesState>(
    "Should emit updated state when removeWatchList is successful",
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right("Success"));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return detailMoviesBloc;
    },
    seed: () => DetailMoviesState.loaded(
      movies: testMovieDetail,
      recommendations: [],
      isAddedToWatchlist: true,
    ),
    act: (bloc) =>
        bloc.add(DetailMoviesEvent.removeFromWatchlist(testMovieDetail)),
    expect: () => [
      DetailMoviesState.loaded(
        movies: testMovieDetail,
        recommendations: [],
        isAddedToWatchlist: false,
      ),
    ],
    verify: (_) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<DetailMoviesBloc, DetailMoviesState>(
    "Should emit error when removeWatchList fails",
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure("Gagal menghapus")));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      return detailMoviesBloc;
    },
    act: (bloc) =>
        bloc.add(DetailMoviesEvent.removeFromWatchlist(testMovieDetail)),
    expect: () => [
      DetailMoviesState.error("Gagal menghapus"),
    ],
    verify: (_) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );
}
