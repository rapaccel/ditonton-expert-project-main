import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/list_movies/list_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../provider/movie_list_notifier_test.mocks.dart';

void main() {
  late ListMoviesBloc listMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    listMoviesBloc = ListMoviesBloc(
        mockGetNowPlayingMovies, mockGetPopularMovies, mockGetTopRatedMovies);
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

  blocTest<ListMoviesBloc, ListMoviesState>(
    'Should emit [loading, loaded] when fetchAll is successful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));

      return listMoviesBloc;
    },
    act: (bloc) => bloc.add(const ListMoviesEvent.fetchAll()),
    expect: () => [
      const ListMoviesState(isLoading: true),
      ListMoviesState(
        isLoading: false,
        nowPlaying: tMovieList,
        popular: tMovieList,
        topRated: tMovieList,
      ),
    ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetPopularMovies.execute());
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<ListMoviesBloc, ListMoviesState>(
    'Should emit [loading, success with empty lists] when fetchAll returns Left',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure("terjadi kesalahan")));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure("terjadi kesalahan")));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure("terjadi kesalahan")));
      return listMoviesBloc;
    },
    act: (bloc) => bloc.add(const ListMoviesEvent.fetchAll()),
    expect: () => [
      const ListMoviesState(isLoading: true),
      const ListMoviesState(
        isLoading: false,
        nowPlaying: [],
        popular: [],
        topRated: [],
        error: null,
      ),
    ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetPopularMovies.execute());
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
