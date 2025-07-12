import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton/common/ioClientHelper.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/detail_movies/detail_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/list_movies/list_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/watch_list/watch_list_bloc.dart';
import 'package:ditonton/presentation/provider/get_now_playing_notifier.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/tv_show/data/dataSources/tv_remote_data_source.dart';
import 'package:ditonton/tv_show/data/repositories/tv_repositories_impl.dart';
import 'package:ditonton/tv_show/domain/repositories/tv_repositories.dart';
import 'package:ditonton/tv_show/domain/useCases/get_on_air_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_popular_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_top_rated_tv.dart';
import 'package:ditonton/tv_show/domain/useCases/get_tv_detail.dart';
import 'package:ditonton/tv_show/domain/useCases/get_tv_recommendation.dart';
import 'package:ditonton/tv_show/domain/useCases/get_watch_list_status.dart';
import 'package:ditonton/tv_show/domain/useCases/remove_watch_list.dart';
import 'package:ditonton/tv_show/domain/useCases/save_watch_list.dart';
import 'package:ditonton/tv_show/domain/useCases/search_tv_show.dart';
import 'package:ditonton/tv_show/presentation/bloc/on_air_tv/on_air_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/search_tv/search_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:ditonton/tv_show/presentation/provider/on_air_tv_notifier.dart';
import 'package:ditonton/tv_show/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/tv_show/presentation/provider/save_watch_list.dart';
import 'package:ditonton/tv_show/presentation/provider/search_tv_notifier.dart';
import 'package:ditonton/tv_show/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/tv_show/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/tv_show/presentation/provider/tv_list_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';

final locator = GetIt.instance;

void init() async {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(() => TvListNotifier(
      getNowAiringTv: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator()));
  locator.registerFactory(
    () => PopularTvNotifier(
      getPopularTv: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvNotifier(
      getTopRatedTv: locator(),
    ),
  );
  locator.registerFactory(() => TvDetailNotifier(
      getTvShowDetail: locator(),
      getTvShowRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator()));
  locator.registerFactory(
      () => GetNowPlayingMoviesNotifier(getNowPlayingMovies: locator()));
  locator.registerFactory(() => OnAirTvNotifier(getOnAirTv: locator()));
  locator.registerFactory(() => SearchTvNotifier(searchTvShow: locator()));
  locator.registerFactory(() => SearchBloc(locator()));
  locator
      .registerFactory(() => ListMoviesBloc(locator(), locator(), locator()));
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(
    () => PopularMoviesBloc(locator()),
  );
  locator.registerFactory(
    () => TopRatedBloc(locator()),
  );
  locator.registerFactory(
    () => WatchListBloc(locator()),
  );
  locator.registerFactory(
    () => DetailMoviesBloc(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(() => TvListBloc(locator(), locator(), locator()));
  locator.registerFactory(() => TopRatedTvBloc(locator()));
  locator.registerFactory(() => OnAirTvBloc(locator()));
  locator.registerFactory(() => PopularTvBloc(locator()));
  locator.registerFactory(() => SearchTvBloc(locator()));
  locator.registerFactory(() =>
      TvDetailBloc(locator(), locator(), locator(), locator(), locator()));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetOnAirTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvRecommendation(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchList(locator()));
  locator.registerLazySingleton(() => RemoveWatchListTv(locator()));
  locator.registerLazySingleton(() => SaveWatchListTv(locator()));
  locator.registerLazySingleton(() => SearchTvShow(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
        networkInfo: locator()),
  );
  locator.registerLazySingleton<TvRepositories>(
    () => TvRepositoriesImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
        networkInfo: locator()),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(ioClient: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(ioClient: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());
  locator.registerLazySingleton(
    () => IOClient(),
  );
  // netwok info
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(locator()),
  );
  final ioClient = await createSecureIOClient();
  locator.registerLazySingleton<IOClient>(() => ioClient);
}
