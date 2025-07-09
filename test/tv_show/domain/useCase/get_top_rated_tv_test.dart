import 'package:dartz/dartz.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/get_popular_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv usecase;
  late MockTvRepositories repositories;

  setUp(() {
    repositories = MockTvRepositories();
    usecase = GetPopularTv(repositories);
  });

  final tTvShows = <TvShow>[];

  test('should get list of popular tv shows from the repository', () async {
    // arrange
    when(repositories.getPopularTvShows())
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShows));
  });
}
