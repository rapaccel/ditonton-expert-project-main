import 'package:dartz/dartz.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/search_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvShow usecase;
  late MockTvRepositories repositories;

  setUp(() {
    repositories = MockTvRepositories();
    usecase = SearchTvShow(repositories);
  });

  final tQuery = "breaking bad";
  final tTvShows = <TvShow>[];

  test('should get list of tv search from the repository', () async {
    // arrange
    when(repositories.searchTvShows(tQuery))
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTvShows));
  });
}
