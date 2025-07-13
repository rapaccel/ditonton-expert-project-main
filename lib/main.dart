import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/presentation/bloc/detail_movies/detail_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/list_movies/list_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/watch_list/watch_list_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/now_playing_movies.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/tv_show/presentation/bloc/on_air_tv/on_air_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/search_tv/search_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.init();
  await di.setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(create: (_) => di.locator<ListMoviesBloc>()),
        BlocProvider(
          create: (_) => di.locator<NowPlayingMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<OnAirTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              final args = settings.arguments as Map<String, dynamic>;
              final isTvShow = args['isTvShow'] ?? false;
              return MaterialPageRoute(
                  builder: (_) => HomeMoviePage(
                        isTvShow: isTvShow,
                      ));
            case PopularMoviesPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              final isTvShow = args['isTvShow'] ?? false;
              return CupertinoPageRoute(
                  builder: (_) => PopularMoviesPage(
                        isTvShow: isTvShow,
                      ));
            case TopRatedMoviesPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              final isTvShow = args['isTvShow'] ?? false;
              return CupertinoPageRoute(
                  builder: (_) => TopRatedMoviesPage(
                        isTvShow: isTvShow,
                      ));
            case NowPlayingMovies.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              final isTvShow = args['isTvShow'] ?? false;
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingMovies(
                        isTvShow: isTvShow,
                      ));
            case MovieDetailPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              final id = args['id'] as int;
              final isTvShow = args['isTvShow'] ?? false;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(
                  id: id,
                  isTvShow: isTvShow,
                ),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              final isTvShow = args['isTvShow'] ?? false;
              return CupertinoPageRoute(
                  builder: (_) => SearchPage(
                        isTvShow: isTvShow,
                      ));
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
