import 'package:dartz/dartz.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_on_air_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnAirTv usecase;
  late MockTvRepositories repositories;

  setUp(() {
    repositories = MockTvRepositories();
    usecase = GetOnAirTv(repositories);
  });

  final tMovies = <TvShow>[];

  test('should get list of tvShow from the repository', () async {
    // arrange
    when(repositories.getOnTheAirTvShows())
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovies));
  });
}
