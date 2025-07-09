import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/useCases/search_tv_show.dart';
import 'package:ditonton/tv_show/presentation/provider/search_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_notifier_test.mocks.dart';

@GenerateMocks([SearchTvShow])
void main() {
  late SearchTvNotifier provider;
  late MockSearchTvShow mockSearchTvShow;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvShow = MockSearchTvShow();
    provider = SearchTvNotifier(searchTvShow: mockSearchTvShow)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTvShow = TvShow(
    name: "name",
    runtime: 1,
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tTvShowList = <TvShow>[tTvShow];
  final tQuery = 'breaking bad';

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTvShow.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTvShow.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowList));
      // act
      await provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tTvShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTvShow.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
