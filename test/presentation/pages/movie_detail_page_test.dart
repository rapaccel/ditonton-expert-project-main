import 'package:ditonton/presentation/bloc/detail_movies/detail_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
      home: ScaffoldMessenger(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<DetailMoviesBloc>.value(value: mockDetailMoviesBloc),
            BlocProvider<TvDetailBloc>.value(value: mockTvDetailBloc),
          ],
          child: Scaffold(body: child),
        ),
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

    await tester.pump(const Duration(milliseconds: 500));

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

    await tester.pump(const Duration(milliseconds: 500));

    // assert
    expect(errorFinder, findsOneWidget);
  });
}
