import 'package:dartz/dartz.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_tv_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendation usecase;
  late MockTvRepositories repositories;

  setUp(() {
    repositories = MockTvRepositories();
    usecase = GetTvRecommendation(repositories);
  });

  final tId = 1;
  final tTvShows = <TvShow>[];

  test('should get list of tv recommendations from the repository', () async {
    // arrange
    when(repositories.getTvRecommendation(tId))
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvShows));
  });
}
