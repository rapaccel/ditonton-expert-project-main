import 'package:dartz/dartz.dart';
import 'package:ditonton/tv_show/domain/useCases/save_watch_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchListTv usecase;
  late MockTvRepositories repositories;

  setUp(() {
    repositories = MockTvRepositories();
    usecase = SaveWatchListTv(repositories);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(repositories.saveWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(repositories.saveWatchlist(testTvDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
