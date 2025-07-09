import 'package:ditonton/tv_show/domain/useCases/get_watch_list_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatusTv usecase;
  late MockTvRepositories repositories;

  setUp(() {
    repositories = MockTvRepositories();
    usecase = GetWatchListStatusTv(repositories);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(repositories.isAddedToWatchlist(1)).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
