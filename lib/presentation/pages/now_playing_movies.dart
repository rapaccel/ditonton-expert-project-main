import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/get_now_playing_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/tv_show/presentation/provider/on_air_tv_notifier.dart';
import 'package:ditonton/tv_show/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingMovies extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-movie';
  final bool isTvShow;

  const NowPlayingMovies({Key? key, this.isTvShow = false}) : super(key: key);

  @override
  _NowPlayingMoviesState createState() => _NowPlayingMoviesState();
}

class _NowPlayingMoviesState extends State<NowPlayingMovies> {
  @override
  void initState() {
    super.initState();
    if (!widget.isTvShow) {
      Future.microtask(() =>
          Provider.of<GetNowPlayingMoviesNotifier>(context, listen: false)
              .fetchTopRatedMovies());
    } else {
      Future.microtask(() =>
          Provider.of<OnAirTvNotifier>(context, listen: false)
              .fetchTopRatedMovies());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.isTvShow ? "On Air TvShow" : "Now Playing Movies"}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !widget.isTvShow
            ? Consumer<GetNowPlayingMoviesNotifier>(
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
            : Consumer<OnAirTvNotifier>(
                builder: (context, data, child) {
                  if (data.state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.state == RequestState.Loaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = data.movies[index];
                        return MovieCard(null, true, movie);
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
              ),
      ),
    );
  }
}
