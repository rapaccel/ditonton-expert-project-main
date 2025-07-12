import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/tv_show/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/tv_show/presentation/provider/popular_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';
  final bool isTvShow;

  const PopularMoviesPage({Key? key, this.isTvShow = false}) : super(key: key);
  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    !widget.isTvShow
        ? Future.microtask(() =>
            // Provider.of<PopularMoviesNotifier>(context, listen: false)
            //     .fetchPopularMovies())
            Provider.of<PopularMoviesBloc>(context, listen: false)
                .add(PopularMoviesEvent.fetch()))
        // : Future.microtask(() =>
        //     Provider.of<PopularTvNotifier>(context, listen: false)
        //         .fetchPopular());
        : Future.microtask(() =>
            context.read<PopularTvBloc>().add(const PopularTvEvent.started()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular ${widget.isTvShow ? "TvShows" : "Movies"}'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: !widget.isTvShow
              // ? Consumer<PopularMoviesNotifier>(
              //     builder: (context, data, child) {
              //       if (data.state == RequestState.Loading) {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       } else if (data.state == RequestState.Loaded) {
              //         return ListView.builder(
              //           itemBuilder: (context, index) {
              //             final movie = data.movies[index];
              //             return MovieCard(movie, false, null);
              //           },
              //           itemCount: data.movies.length,
              //         );
              //       } else {
              //         return Center(
              //           key: Key('error_message'),
              //           child: Text(data.message),
              //         );
              //       }
              //     },
              //   )
              ? BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                  builder: (context, state) {
                    return state.when(
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        loaded: (movies) => ListView.builder(
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return MovieCard(movie, false, null);
                              },
                              itemCount: movies.length,
                            ),
                        error: (message) => Center(
                              key: Key('error_message'),
                              child: Text(message),
                            ));
                  },
                )
              // : Consumer<PopularTvNotifier>(
              //     builder: (context, data, child) {
              //       if (data.popularTvShowsState == RequestState.Loading) {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       } else if (data.popularTvShowsState ==
              //           RequestState.Loaded) {
              //         return ListView.builder(
              //           itemBuilder: (context, index) {
              //             final movie = data.popularTvShows[index];
              //             return MovieCard(null, true, movie);
              //           },
              //           itemCount: data.popularTvShows.length,
              //         );
              //       } else {
              //         return Center(
              //           key: Key('error_message'),
              //           child: Text(data.message),
              //         );
              //       }
              //     },
              //   )),
              : BlocBuilder<PopularTvBloc, PopularTvState>(
                  builder: (context, state) {
                    return state.when(
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        loaded: (tvShows) => ListView.builder(
                              itemBuilder: (context, index) {
                                final tvShow = tvShows[index];
                                return MovieCard(null, true, tvShow);
                              },
                              itemCount: tvShows.length,
                            ),
                        empty: () =>
                            Center(child: Text('No TV shows available')),
                        error: (message) => Center(
                              key: Key('error_message'),
                              child: Text(message),
                            ));
                  },
                )),
    );
  }
}
