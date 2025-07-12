import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_detail_notifier_test.mocks.dart';

void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvShowDetail;
  late MockGetTvRecommendation mockGetTvShowRecommendations;
  late MockSaveWatchListTv mockAddToWatchlist;
  late MockRemoveWatchListTv mockRemoveFromWatchlist;
  late MockGetWatchListStatusTv mockGetWatchlistStatus;

  setUp(() {
    mockGetTvShowDetail = MockGetTvDetail();
    mockGetTvShowRecommendations = MockGetTvRecommendation();
    mockAddToWatchlist = MockSaveWatchListTv();
    mockRemoveFromWatchlist = MockRemoveWatchListTv();
    mockGetWatchlistStatus = MockGetWatchListStatusTv();
    tvDetailBloc = TvDetailBloc(
      mockGetTvShowDetail,
      mockAddToWatchlist,
      mockRemoveFromWatchlist,
      mockGetWatchlistStatus,
      mockGetTvShowRecommendations,
    );
  });

  blocTest<TvDetailBloc, TvDetailState>(
      "Should return [loading, loaded] when get data is succes",
      build: () {
        when(mockGetTvShowDetail.execute(1))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvShowRecommendations.execute(1))
            .thenAnswer((_) async => Right(testTvShowList));
        when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(TvDetailEvent.fetch(1)),
      expect: () => [
            TvDetailState.loading(),
            TvDetailState.loaded(
              tvDetail: testTvDetail,
              recommendations: testTvShowList,
              isAddedToWatchlist: false,
            )
          ],
      verify: (_) {
        verify(mockGetTvShowDetail.execute(1));
        verify(mockGetTvShowRecommendations.execute(1));
        verify(mockGetWatchlistStatus.execute(1));
      });

  blocTest<TvDetailBloc, TvDetailState>(
    "Should return [loading, error] when get data all failed",
    build: () {
      when(mockGetTvShowDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      when(mockGetTvShowRecommendations.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('terjadi kesalahan')));
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(TvDetailEvent.fetch(1)),
    expect: () =>
        [TvDetailState.loading(), TvDetailState.error("terjadi kesalahan")],
    verify: (bloc) {
      verify(mockGetTvShowDetail.execute(1));
      verify(mockGetTvShowRecommendations.execute(1));
      verify(mockGetWatchlistStatus.execute(1));
    },
  );
  blocTest<TvDetailBloc, TvDetailState>(
    "Should return [loading, empty] when get data is empty",
    build: () {
      when(mockGetTvShowDetail.execute(1))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvShowRecommendations.execute(1))
          .thenAnswer((_) async => Right([]));
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(TvDetailEvent.fetch(1)),
    expect: () => [
      TvDetailState.loading(),
      TvDetailState.loaded(
        tvDetail: testTvDetail,
        recommendations: [],
        isAddedToWatchlist: false,
      )
    ],
    verify: (bloc) {
      verify(mockGetTvShowDetail.execute(1));
      verify(mockGetTvShowRecommendations.execute(1));
      verify(mockGetWatchlistStatus.execute(1));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    "Should return [loading, loaded] when add to watchlist is success",
    build: () {
      when(mockAddToWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right("Success"));
      return tvDetailBloc;
    },
    seed: () => TvDetailState.loaded(
      tvDetail: testTvDetail,
      recommendations: [],
      isAddedToWatchlist: false,
    ),
    act: (bloc) => bloc.add(TvDetailEvent.addToWatchlist(testTvDetail)),
    expect: () => [
      TvDetailState.loaded(
        tvDetail: testTvDetail,
        recommendations: [],
        isAddedToWatchlist: true,
      )
    ],
    verify: (bloc) {
      verify(mockAddToWatchlist.execute(testTvDetail));
    },
  );
  blocTest<TvDetailBloc, TvDetailState>(
    "Should return [error] when add to watchlist is failed",
    build: () {
      when(mockAddToWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure("Gagal menambahkan")));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(TvDetailEvent.addToWatchlist(testTvDetail)),
    expect: () => [
      TvDetailState.error("Gagal menambahkan"),
    ],
    verify: (_) {
      verify(mockAddToWatchlist.execute(testTvDetail));
    },
  );
  blocTest<TvDetailBloc, TvDetailState>(
    "Should return [loading, loaded] when remove from watchlist is success",
    build: () {
      when(mockRemoveFromWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right("Success"));
      return tvDetailBloc;
    },
    seed: () => TvDetailState.loaded(
      tvDetail: testTvDetail,
      recommendations: [],
      isAddedToWatchlist: true,
    ),
    act: (bloc) => bloc.add(TvDetailEvent.removeFromWatchlist(testTvDetail)),
    expect: () => [
      TvDetailState.loaded(
        tvDetail: testTvDetail,
        recommendations: [],
        isAddedToWatchlist: false,
      )
    ],
    verify: (bloc) {
      verify(mockRemoveFromWatchlist.execute(testTvDetail));
    },
  );
  blocTest<TvDetailBloc, TvDetailState>(
    "Should return [error] when remove from watchlist is failed",
    build: () {
      when(mockRemoveFromWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure("Gagal menghapus")));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(TvDetailEvent.removeFromWatchlist(testTvDetail)),
    expect: () => [
      TvDetailState.error("Gagal menghapus"),
    ],
    verify: (_) {
      verify(mockRemoveFromWatchlist.execute(testTvDetail));
    },
  );
}
