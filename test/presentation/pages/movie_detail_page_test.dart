import 'package:ditonton/presentation/bloc/detail_movies/detail_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockDetailMoviesBloc extends Mock implements DetailMoviesBloc {}

class MockTvDetailBloc extends Mock implements TvDetailBloc {}

void main() {
  late MockDetailMoviesBloc mockDetailMoviesBloc;
  late MockTvDetailBloc mockTvDetailBloc;

  setUp(() {
    mockDetailMoviesBloc = MockDetailMoviesBloc();
    mockTvDetailBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget({
    required Widget child,
  }) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<DetailMoviesBloc>.value(value: mockDetailMoviesBloc),
          BlocProvider<TvDetailBloc>.value(value: mockTvDetailBloc),
        ],
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('Page should display loading when data is loading',
      (WidgetTester tester) async {
    // arrange
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState.loading());
    when(() => mockTvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailState.loading())); // INI WAJIB

    final loadingFinder = find.byType(CircularProgressIndicator);

    // act
    await tester.pumpWidget(_makeTestableWidget(
      child: MovieDetailPage(id: 1, isTvShow: true),
    ));

    await tester.pump(); // build widget dan jalankan stream

    // assert
    expect(loadingFinder, findsOneWidget);
  });
  testWidgets('Page should display error message when data fetch fails',
      (WidgetTester tester) async {
    // arrange
    when(() => mockTvDetailBloc.state)
        .thenReturn(TvDetailState.error('Error fetching data'));
    when(() => mockTvDetailBloc.stream).thenAnswer(
        (_) => Stream.value(TvDetailState.error('Error fetching data')));

    final errorFinder = find.text('Error fetching data');

    // act
    await tester.pumpWidget(_makeTestableWidget(
      child: MovieDetailPage(id: 1, isTvShow: true),
    ));

    await tester.pump(); // build widget dan jalankan stream

    // assert
    expect(errorFinder, findsOneWidget);
  });

  testWidgets('Page should display movie details when data is loaded tv',
      (WidgetTester tester) async {
    // arrange
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState.loaded(
        isAddedToWatchlist: false,
        tvDetail: testTvDetail,
        recommendations: []));
    when(() => mockTvDetailBloc.stream).thenAnswer((_) => Stream.value(
        TvDetailState.loaded(
            isAddedToWatchlist: false,
            tvDetail: testTvDetail,
            recommendations: [])));
    when(() => mockDetailMoviesBloc.state)
        .thenReturn(DetailMoviesState.initial());
    when(() => mockDetailMoviesBloc.stream)
        .thenAnswer((_) => Stream<DetailMoviesState>.empty());
    final titleFinder = find.text(testTvDetail.name);
    final overviewFinder = find.text(testTvDetail.overview);

    // act
    await tester.pumpWidget(_makeTestableWidget(
      child: MovieDetailPage(id: 1, isTvShow: true),
    ));

    await tester.pump();

    // assert
    expect(titleFinder, findsOneWidget);
    expect(overviewFinder, findsOneWidget);
  });

  testWidgets('Page should display movie details when data is loaded movie',
      (WidgetTester tester) async {
    // arrange
    when(() => mockDetailMoviesBloc.state).thenReturn(DetailMoviesState.loaded(
        isAddedToWatchlist: false,
        movies: testMovieDetail,
        recommendations: []));
    when(() => mockDetailMoviesBloc.stream).thenAnswer((_) => Stream.value(
        DetailMoviesState.loaded(
            isAddedToWatchlist: false,
            movies: testMovieDetail,
            recommendations: [])));
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState.initial());
    when(() => mockTvDetailBloc.stream)
        .thenAnswer((_) => Stream<TvDetailState>.empty());
    final titleFinder = find.text(testMovieDetail.title);
    final overviewFinder = find.text(testMovieDetail.overview);

    // act
    await tester.pumpWidget(_makeTestableWidget(
      child: MovieDetailPage(id: testMovieDetail.id, isTvShow: false),
    ));

    await tester.pump();

    // assert
    expect(titleFinder, findsOneWidget);
    expect(overviewFinder, findsOneWidget);
  });

  testWidgets('Watchlist button should be present',
      (WidgetTester tester) async {
    // arrange
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState.loaded(
        isAddedToWatchlist: false,
        tvDetail: testTvDetail,
        recommendations: []));
    when(() => mockTvDetailBloc.stream).thenAnswer((_) => Stream.value(
        TvDetailState.loaded(
            isAddedToWatchlist: false,
            tvDetail: testTvDetail,
            recommendations: [])));
    when(() => mockDetailMoviesBloc.state)
        .thenReturn(DetailMoviesState.initial());
    when(() => mockDetailMoviesBloc.stream)
        .thenAnswer((_) => const Stream.empty());

    final watchlistButtonFinder = find.byKey(Key('watchlist_button'));

    // act
    await tester.pumpWidget(_makeTestableWidget(
      child: MovieDetailPage(id: 1, isTvShow: true),
    ));

    await tester.pump();

    // assert
    expect(watchlistButtonFinder, findsOneWidget);
  });

  testWidgets('Recommendation tv list should be displayed',
      (WidgetTester tester) async {
    // arrange
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState.loaded(
        isAddedToWatchlist: false,
        tvDetail: testTvDetail,
        recommendations: [testTvShow]));
    when(() => mockTvDetailBloc.stream).thenAnswer((_) => Stream.value(
        TvDetailState.loaded(
            isAddedToWatchlist: false,
            tvDetail: testTvDetail,
            recommendations: [testTvShow])));
    when(() => mockDetailMoviesBloc.state)
        .thenReturn(DetailMoviesState.initial());
    when(() => mockDetailMoviesBloc.stream)
        .thenAnswer((_) => const Stream.empty());

    final recommendationFinder = find.byKey(ValueKey('recommendation_1'));

    // act
    await tester.pumpWidget(_makeTestableWidget(
      child: MovieDetailPage(id: 1, isTvShow: true),
    ));

    await tester.pump();

    // assert
    expect(recommendationFinder, findsOneWidget);
  });

  testWidgets('Recommendation movie list should be displayed',
      (WidgetTester tester) async {
    // arrange
    when(() => mockDetailMoviesBloc.state).thenReturn(DetailMoviesState.loaded(
        isAddedToWatchlist: false,
        movies: testMovieDetail,
        recommendations: [testMovie]));
    when(() => mockDetailMoviesBloc.stream).thenAnswer((_) => Stream.value(
        DetailMoviesState.loaded(
            isAddedToWatchlist: false,
            movies: testMovieDetail,
            recommendations: [testMovie])));
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState.initial());
    when(() => mockTvDetailBloc.stream)
        .thenAnswer((_) => const Stream<TvDetailState>.empty());
    final recommendationFinder =
        find.byKey(ValueKey('recommendation_${testMovie.id}'));

    // act
    await tester.pumpWidget(_makeTestableWidget(
      child: MovieDetailPage(id: testMovieDetail.id, isTvShow: false),
    ));

    await tester.pump();

    // assert
    expect(recommendationFinder, findsOneWidget);
  });
}
