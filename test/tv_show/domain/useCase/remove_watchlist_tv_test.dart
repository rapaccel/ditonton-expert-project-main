import 'package:dartz/dartz.dart';
import 'package:ditonton/tv_show/domain/useCases/remove_watch_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchListTv usecase;
  late MockTvRepositories repositories;

  setUp(() {
    repositories = MockTvRepositories();
    usecase = RemoveWatchListTv(repositories);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(repositories.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(repositories.removeWatchlist(testTvDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
