import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/tv_show/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';
  final bool isTvShow;

  const TopRatedMoviesPage({Key? key, this.isTvShow = false}) : super(key: key);

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    if (!widget.isTvShow) {
      Future.microtask(() =>
          Provider.of<TopRatedMoviesNotifier>(context, listen: false)
              .fetchTopRatedMovies());
    } else {
      Future.microtask(() =>
          Provider.of<TopRatedTvNotifier>(context, listen: false)
              .fetchTopRated());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated ${widget.isTvShow ? "TvShow" : "Movies"}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !widget.isTvShow
            ? Consumer<TopRatedMoviesNotifier>(
                builder: (context, data, child) {
                  if (data.state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.state == RequestState.Loaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = data.movies[index];
                        return MovieCard(movie, false, null);
                      },
                      itemCount: data.movies.length,
                    );
                  } else {
                    return Center(
                      key: Key('error_message'),
                      child: Text(data.message),
                    );
                  }
                },
              )
            : Consumer<TopRatedTvNotifier>(
                builder: (context, data, child) {
                  if (data.topRatedTvShowsState == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.topRatedTvShowsState == RequestState.Loaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = data.topRatedTvShows[index];
                        return MovieCard(null, true, movie);
                      },
                      itemCount: data.topRatedTvShows.length,
                    );
                  } else {
                    return Center(
                      key: Key('error_message'),
                      child: Text(data.message),
                    );
                  }
                },
              ),
      ),
    );
  }
}
