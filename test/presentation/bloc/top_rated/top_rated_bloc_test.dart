import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../provider/movie_list_notifier_test.mocks.dart';

void main() {
  late TopRatedBloc topRatedBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedBloc = TopRatedBloc(mockGetTopRatedMovies);
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

  blocTest<TopRatedBloc, TopRatedState>(
    "Should return [loading, loaded] when get data is succes",
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedBloc;
    },
    act: (bloc) => bloc.add(TopRatedEvent.fetch()),
    expect: () => [TopRatedState.loading(), TopRatedState.loaded(tMovieList)],
    verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
  );

  blocTest<TopRatedBloc, TopRatedState>(
    "Should return [loading, error] when get data is succes",
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      return topRatedBloc;
    },
    act: (bloc) => bloc.add(TopRatedEvent.fetch()),
    expect: () =>
        [TopRatedState.loading(), TopRatedState.error("terjadi kesalahan")],
    verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
  );
}
