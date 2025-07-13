import 'package:ditonton/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/tv_show/presentation/bloc/popular_tv/popular_tv_bloc.dart';
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
            Provider.of<PopularMoviesBloc>(context, listen: false)
                .add(PopularMoviesEvent.fetch()))
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
