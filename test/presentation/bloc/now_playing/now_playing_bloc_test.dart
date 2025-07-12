import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/now_playing/now_playing_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../provider/movie_list_notifier_test.mocks.dart';

void main() {
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMoviesBloc(mockGetNowPlayingMovies);
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

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    "Should return [loading, loaded] when get data is succes",
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(NowPlayingMoviesEvent.fetch()),
    expect: () => [
      NowPlayingMoviesState.loading(),
      NowPlayingMoviesState.loaded(tMovieList)
    ],
    verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    "Should return [loading, error] when get data is succes",
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(NowPlayingMoviesEvent.fetch()),
    expect: () => [
      NowPlayingMoviesState.loading(),
      NowPlayingMoviesState.error("terjadi kesalahan")
    ],
    verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
  );
}
