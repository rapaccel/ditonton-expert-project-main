import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/list_movies/list_movies_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_movies.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      Provider.of<TvListBloc>(context, listen: false)
          .add(const TvListEvent.fetch());
    } else {
      Provider.of<ListMoviesBloc>(context, listen: false)
          .add(const ListMoviesEvent.fetchAll());
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
                BlocBuilder<ListMoviesBloc, ListMoviesState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.nowPlaying.isNotEmpty) {
                      return MovieList(movies: state.nowPlaying);
                    } else {
                      return Text('Failed to load now playing movies');
                    }
                  },
                ),
              if (widget.isTvShow)
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    return state.when(
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                      loaded: (onAir, popular, topRated) {
                        return MovieList(tvShows: onAir);
                      },
                      error: (message) => Text(message),
                      empty: () => Text('No TV shows available'),
                    );
                  },
                ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(
                    context, PopularMoviesPage.ROUTE_NAME,
                    arguments: {'isTvShow': widget.isTvShow}),
              ),
              if (!widget.isTvShow)
                BlocBuilder<ListMoviesBloc, ListMoviesState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.popular.isNotEmpty) {
                      return MovieList(movies: state.popular);
                    } else {
                      return Text('Failed to load popular movies');
                    }
                  },
                ),
              if (widget.isTvShow)
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    return state.when(
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                      loaded: (onAir, popular, topRated) {
                        return MovieList(tvShows: popular);
                      },
                      error: (message) => Text(message),
                      empty: () => Text('No TV shows available'),
                    );
                  },
                ),
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
                BlocBuilder<ListMoviesBloc, ListMoviesState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.topRated.isNotEmpty) {
                      return MovieList(movies: state.topRated);
                    } else {
                      return Text('Failed to load top rated movies');
                    }
                  },
                ),
              if (widget.isTvShow)
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    return state.when(
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                      loaded: (onAir, popular, topRated) {
                        return MovieList(tvShows: topRated);
                      },
                      error: (message) => Text(message),
                      empty: () => Text('No TV shows available'),
                    );
                  },
                ),
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
                  key: ValueKey('movie_$id'),
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
