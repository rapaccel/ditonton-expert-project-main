import 'package:dartz/dartz.dart';
import 'package:ditonton/tv_show/domain/useCases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepositories mockTvRepositories;

  setUp(() {
    mockTvRepositories = MockTvRepositories();
    usecase = GetTvDetail(mockTvRepositories);
  });

  final tId = 1;

  test('should get tv detail from the repository', () async {
    // arrange
    when(mockTvRepositories.getTvShowDetail(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvDetail));
  });
}
