import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_movies.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/presentation/provider/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  final bool isTvShow;

  const HomeMoviePage({Key? key, this.isTvShow = false}) : super(key: key);

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    if (widget.isTvShow) {
      Future.microtask(
        () => Provider.of<TvListNotifier>(context, listen: false)
          ..fetchNowAiring()
          ..fetchPopular()
          ..fetchTopRated(),
      );
      return;
    } else {
      Future.microtask(
          () => Provider.of<MovieListNotifier>(context, listen: false)
            ..fetchNowPlayingMovies()
            ..fetchPopularMovies()
            ..fetchTopRatedMovies());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, '/home',
                    arguments: {'isTvShow': false});
              },
            ),
            ListTile(
              leading: Icon(Icons.live_tv_rounded),
              title: Text('Tv Series'),
              onTap: () {
                Navigator.pushNamed(context, '/home',
                    arguments: {'isTvShow': true});
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: widget.isTvShow
            ? Text('Ditonton Tv Show')
            : Text("Ditonton Movies"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME,
                  arguments: {'isTvShow': widget.isTvShow});
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: '${widget.isTvShow ? "On Air Tv" : "Now Playing"}',
                onTap: () => Navigator.pushNamed(
                    context, NowPlayingMovies.ROUTE_NAME,
                    arguments: {'isTvShow': widget.isTvShow}),
              ),
              if (!widget.isTvShow)
                Consumer<MovieListNotifier>(builder: (context, data, child) {
                  final state = data.nowPlayingState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return MovieList(movies: data.nowPlayingMovies);
                  } else {
                    return Text('Failed');
                  }
                }),
              if (widget.isTvShow)
                Consumer<TvListNotifier>(builder: (context, data, child) {
                  final state = data.nowAiringState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return MovieList(tvShows: data.nowAiringTvShows);
                  } else {
                    return Text('Failed');
                  }
                }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(
                    context, PopularMoviesPage.ROUTE_NAME,
                    arguments: {'isTvShow': widget.isTvShow}),
              ),
              if (!widget.isTvShow)
                Consumer<MovieListNotifier>(builder: (context, data, child) {
                  final state = data.popularMoviesState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return MovieList(movies: data.popularMovies);
                  } else {
                    return Text('Failed');
                  }
                }),
              if (widget.isTvShow)
                Consumer<TvListNotifier>(builder: (context, data, child) {
                  final state = data.popularTvShowsState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return MovieList(tvShows: data.popularTvShows);
                  } else {
                    return Text('Failed');
                  }
                }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedMoviesPage.ROUTE_NAME,
                  arguments: {
                    'isTvShow': widget.isTvShow,
                  },
                ),
              ),
              if (!widget.isTvShow)
                Consumer<MovieListNotifier>(builder: (context, data, child) {
                  final state = data.topRatedMoviesState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return MovieList(
                      movies: data.topRatedMovies,
                    );
                  } else {
                    return Text('Failed');
                  }
                }),
              if (widget.isTvShow)
                Consumer<TvListNotifier>(builder: (context, data, child) {
                  final state = data.topRatedTvShowsState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return MovieList(tvShows: data.topRatedTvShows);
                  } else {
                    return Text('Failed');
                  }
                }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie>? movies;
  final List<TvShow>? tvShows;

  const MovieList({Key? key, this.movies, this.tvShows})
      : assert(movies != null || tvShows != null,
            'Either movies or tvShows must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMovieList = movies != null && movies!.isNotEmpty;
    final items = isMovieList ? movies! : tvShows!;

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final posterPath = isMovieList
              ? (item as Movie).posterPath
              : (item as TvShow).posterPath;
          final id = isMovieList ? (item as Movie).id : (item as TvShow).id;
          final route = isMovieList
              ? MovieDetailPage.ROUTE_NAME
              : MovieDetailPage.ROUTE_NAME;

          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  route,
                  arguments: {'id': id, 'isTvShow': isMovieList ? false : true},
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL$posterPath',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
