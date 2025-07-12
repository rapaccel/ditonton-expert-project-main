import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../provider/movie_list_notifier_test.mocks.dart';

void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
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

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    "Should return [loading, loaded] when get data is succes",
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(PopularMoviesEvent.fetch()),
    expect: () =>
        [PopularMoviesState.loading(), PopularMoviesState.loaded(tMovieList)],
    verify: (bloc) => verify(mockGetPopularMovies.execute()),
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    "Should return [loading, error] when get data is succes",
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(PopularMoviesEvent.fetch()),
    expect: () => [
      PopularMoviesState.loading(),
      PopularMoviesState.error("terjadi kesalahan")
    ],
    verify: (bloc) => verify(mockGetPopularMovies.execute()),
  );
}
