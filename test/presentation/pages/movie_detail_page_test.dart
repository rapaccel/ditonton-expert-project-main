import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/detail_movies/detail_movies_bloc.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
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
}
