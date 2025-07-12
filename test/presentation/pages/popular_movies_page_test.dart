import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/tv_show/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularMoviesBloc extends Mock implements PopularMoviesBloc {}

class FakePopularMoviesState extends Fake implements PopularMoviesState {}

class FakePopularMoviesEvent extends Fake implements PopularMoviesEvent {}

class MockPopularTvBloc extends Mock implements PopularTvBloc {}

class FakePopularTvEvent extends Fake implements PopularTvEvent {}

class FakePopularTvState extends Fake implements PopularTvState {}

void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockPopularTvBloc mockPopularTvBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularMoviesState());
    registerFallbackValue(FakePopularMoviesEvent());
    registerFallbackValue(FakePopularTvState());
    registerFallbackValue(FakePopularTvEvent());
  });

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockPopularTvBloc = MockPopularTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PopularMoviesBloc>.value(
            value: mockPopularMoviesBloc,
          ),
          BlocProvider<PopularTvBloc>.value(
            value: mockPopularTvBloc,
          ),
        ],
        child: Scaffold(body: body),
      ),
    );
  }

  testWidgets('should show CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesState.loading());

    whenListen(
      mockPopularMoviesBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: PopularMoviesState.loading(),
    );

    await tester.pumpWidget(_makeTestableWidget(
      BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (movies) => ListView.builder(
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie, false, null);
              },
              itemCount: movies.length,
            ),
            error: (message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
          );
        },
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show MovieCard list when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesState.loaded(testMovieList));

    whenListen(
      mockPopularMoviesBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: PopularMoviesState.loaded(
        testMovieList,
      ),
    );
    await tester.pumpWidget(_makeTestableWidget(
      BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (movies) => ListView.builder(
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie, false, null);
              },
              itemCount: movies.length,
            ),
            error: (message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
          );
        },
      ),
    ));

    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets('should show error message when state is error',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesState.error("Failed to load"));

    whenListen(
      mockPopularMoviesBloc,
      Stream<PopularMoviesState>.empty(),
      initialState: PopularMoviesState.error(
        "Failed to load",
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(
      BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (movies) => ListView.builder(
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie, false, null);
              },
              itemCount: movies.length,
            ),
            error: (message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
          );
        },
      ),
    ));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Failed to load'), findsOneWidget);
  });

  testWidgets('should show CircularProgressIndicator when loading (tvshow)',
      (WidgetTester tester) async {
    when(() => mockPopularTvBloc.state).thenReturn(PopularTvState.loading());

    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: PopularTvState.loading(),
    );

    await tester.pumpWidget(_makeTestableWidget(
      BlocBuilder<PopularTvBloc, PopularTvState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (movies) => ListView.builder(
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(null, true, movie);
              },
              itemCount: movies.length,
            ),
            error: (message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
            empty: () => const Center(child: Text('No Data')),
          );
        },
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show moviecar when loaded (tvshow)',
      (WidgetTester tester) async {
    when(() => mockPopularTvBloc.state)
        .thenReturn(PopularTvState.loaded(testTvShowList));

    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: PopularTvState.loaded(testTvShowList),
    );

    await tester.pumpWidget(_makeTestableWidget(
      BlocBuilder<PopularTvBloc, PopularTvState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (movies) => ListView.builder(
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(null, true, movie);
              },
              itemCount: movies.length,
            ),
            error: (message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
            empty: () => const Center(child: Text('No Data')),
          );
        },
      ),
    ));
    expect(find.byType(MovieCard), findsOneWidget);
    expect(find.text('name'), findsOneWidget);
  });

  testWidgets('should show error when error (tvshow)',
      (WidgetTester tester) async {
    when(() => mockPopularTvBloc.state)
        .thenReturn(PopularTvState.error("terjadi kesalahan"));

    whenListen(
      mockPopularTvBloc,
      Stream<PopularTvState>.empty(),
      initialState: PopularTvState.error("terjadi kesalahan"),
    );

    await tester.pumpWidget(_makeTestableWidget(
      BlocBuilder<PopularTvBloc, PopularTvState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (movies) => ListView.builder(
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(null, true, movie);
              },
              itemCount: movies.length,
            ),
            error: (message) => Center(
              key: const Key('error_message'),
              child: Text(message),
            ),
            empty: () => const Center(child: Text('No Data')),
          );
        },
      ),
    ));
    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('terjadi kesalahan'), findsOneWidget);
  });
}
