import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';

class MockTopRatedMoviesBloc extends Mock implements TopRatedBloc {}

class FakeTopRatedMoviesState extends Fake implements TopRatedState {}

class FakeTopRatedMoviesEvent extends Fake implements TopRatedEvent {}

class MockTopRatedTvBloc extends Mock implements TopRatedTvBloc {}

class FakeTopRatedTvEvent extends Fake implements TopRatedTvEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedTvState {}

@GenerateMocks([TopRatedMoviesNotifier])
void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedMoviesState());
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedTvState());
    registerFallbackValue(FakeTopRatedTvEvent());
  });
  setUp(() {
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TopRatedBloc>.value(
            value: mockTopRatedMoviesBloc,
          ),
          BlocProvider<TopRatedTvBloc>.value(
            value: mockTopRatedTvBloc,
          ),
        ],
        child: Scaffold(body: body),
      ),
    );
  }

  testWidgets('should show CircularProgressIndicator when loading (movies)',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedState.loading());

    whenListen(
      mockTopRatedMoviesBloc,
      Stream<TopRatedState>.empty(),
      initialState: TopRatedState.loading(),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show CircularProgressIndicator when loading (tv shows)',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state).thenReturn(TopRatedTvState.loading());

    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: TopRatedTvState.loading(),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage(
      isTvShow: true,
    )));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show ListView when loaded (movies)',
      (WidgetTester tester) async {
    final movies = <Movie>[testMovie];
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedState.loaded(movies));

    whenListen(
      mockTopRatedMoviesBloc,
      Stream<TopRatedState>.empty(),
      initialState: TopRatedState.loaded(movies),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('should show ListView when loaded (tvShows)',
      (WidgetTester tester) async {
    final movies = <TvShow>[testTvShow];
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(TopRatedTvState.loaded(movies));

    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: TopRatedTvState.loaded(movies),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage(
      isTvShow: true,
    )));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('should show error message when error (movies)',
      (WidgetTester tester) async {
    const errorMessage = 'Error occurred';
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedState.error(errorMessage));

    whenListen(
      mockTopRatedMoviesBloc,
      Stream<TopRatedState>.empty(),
      initialState: TopRatedState.error(errorMessage),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should show error message when error (tv shows)',
      (WidgetTester tester) async {
    const errorMessage = 'Error occurred';
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(TopRatedTvState.error(errorMessage));

    whenListen(
      mockTopRatedTvBloc,
      Stream<TopRatedTvState>.empty(),
      initialState: TopRatedTvState.error(errorMessage),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage(
      isTvShow: true,
    )));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
