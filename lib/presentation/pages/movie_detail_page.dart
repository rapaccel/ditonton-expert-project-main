import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/detail_movies/detail_movies_bloc.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show_detail.dart';
import 'package:ditonton/tv_show/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final bool isTvShow;
  final int id;
  MovieDetailPage({required this.id, this.isTvShow = false});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isTvShow) {
      Future.microtask(() {
        Provider.of<TvDetailBloc>(context, listen: false)
            .add(TvDetailEvent.fetch(widget.id));
      });
    } else {
      Future.microtask(() {
        Provider.of<DetailMoviesBloc>(context, listen: false)
            .add(DetailMoviesEvent.fetch(widget.id));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isTvShow) {
      return Scaffold(
        body: BlocBuilder<DetailMoviesBloc, DetailMoviesState>(
          builder: (context, state) {
            return state.when(
              initial: () => Center(child: Text('Initial State')),
              loading: () => Center(child: CircularProgressIndicator()),
              loaded: (movies, recommendations, isAddedToWatchlist) {
                final movie = movies;
                return SafeArea(
                  child: DetailContent(
                    isTvShow: widget.isTvShow,
                    movie: movie,
                    movieRecommendations: recommendations,
                    isAddedWatchlist: isAddedToWatchlist,
                  ),
                );
              },
              error: (message) => Center(child: Text(message)),
              empty: () => Center(child: Text('No Data')),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        body: BlocBuilder<TvDetailBloc, TvDetailState>(
          builder: (context, state) {
            return state.when(
              initial: () => Center(child: Text('Initial State')),
              loading: () => Center(child: CircularProgressIndicator()),
              loaded: (tvDetail, recommendations, isAddedToWatchlist) {
                final tvShow = tvDetail;
                return SafeArea(
                  child: DetailContent(
                    isTvShow: widget.isTvShow,
                    tvShow: tvShow,
                    tvShowRecommendations: recommendations,
                    isAddedWatchlist: isAddedToWatchlist,
                  ),
                );
              },
              error: (message) => Center(child: Text(message)),
              empty: () => Center(child: Text('No Data')),
            );
          },
        ),
      );
    }
  }
}

class DetailContent extends StatelessWidget {
  final bool isTvShow;
  final MovieDetail? movie;
  final TvShowDetail? tvShow;
  final List<Movie>? movieRecommendations;
  final List<TvShow>? tvShowRecommendations;
  final bool isAddedWatchlist;

  const DetailContent({
    Key? key,
    required this.isTvShow,
    this.movie,
    this.tvShow,
    this.movieRecommendations,
    this.tvShowRecommendations,
    required this.isAddedWatchlist,
  })  : assert((isTvShow && tvShow != null) || (!isTvShow && movie != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final posterPath = isTvShow ? tvShow!.posterPath : movie!.posterPath;
    final title = isTvShow ? tvShow!.name : movie!.title;
    final overview = isTvShow ? tvShow!.overview : movie!.overview;
    final genres = isTvShow ? tvShow!.genres : movie!.genres;
    final runtime = isTvShow ? tvShow!.runtime : movie!.runtime;
    final voteAverage = isTvShow ? tvShow!.voteAverage : movie!.voteAverage;
    return Stack(
      children: [
        CachedNetworkImage(
          key: ValueKey('poster_$posterPath'),
          imageUrl: 'https://image.tmdb.org/t/p/w500${posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: kHeading5,
                            ),
                            MultiBlocListener(
                              listeners: [
                                BlocListener<DetailMoviesBloc,
                                    DetailMoviesState>(
                                  listenWhen: (previous, current) {
                                    final prevIsAdded = previous.maybeWhen(
                                      loaded: (_, __, isAdded) => isAdded,
                                      orElse: () => null,
                                    );
                                    final currIsAdded = current.maybeWhen(
                                      loaded: (_, __, isAdded) => isAdded,
                                      orElse: () => null,
                                    );
                                    return prevIsAdded != null &&
                                        currIsAdded != null &&
                                        prevIsAdded != currIsAdded;
                                  },
                                  listener: (context, state) {
                                    final message = state.maybeWhen(
                                      orElse: () => '',
                                      error: (msg) => msg,
                                      loaded: (movies, recommendations,
                                              isAdded) =>
                                          isAdded
                                              ? "Bookmark added to watchlist"
                                              : "Bookmark removed from watchlist",
                                    );
                                    if (message.isNotEmpty) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text(message)),
                                        );
                                      });
                                    }
                                  },
                                ),
                                BlocListener<TvDetailBloc, TvDetailState>(
                                  listenWhen: (previous, current) {
                                    final prevIsAdded = previous.maybeWhen(
                                      loaded: (_, __, isAdded) => isAdded,
                                      orElse: () => null,
                                    );
                                    final currIsAdded = current.maybeWhen(
                                      loaded: (_, __, isAdded) => isAdded,
                                      orElse: () => null,
                                    );
                                    return prevIsAdded != null &&
                                        currIsAdded != null &&
                                        prevIsAdded != currIsAdded;
                                  },
                                  listener: (context, state) {
                                    final message = state.maybeWhen(
                                      orElse: () => '',
                                      error: (msg) => msg,
                                      loaded: (tvDetail, recommendations,
                                              isAdded) =>
                                          isAdded
                                              ? "Bookmark added to watchlist"
                                              : "Bookmark removed from watchlist",
                                    );
                                    if (message.isNotEmpty) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text(message)),
                                        );
                                      });
                                    }
                                  },
                                ),
                              ],
                              child: FilledButton(
                                key: Key('watchlist_button'),
                                onPressed: () async {
                                  if (!isAddedWatchlist) {
                                    if (isTvShow) {
                                      Provider.of<TvDetailBloc>(context,
                                              listen: false)
                                          .add(TvDetailEvent.addToWatchlist(
                                              tvShow!));
                                    } else {
                                      Provider.of<DetailMoviesBloc>(context,
                                              listen: false)
                                          .add(DetailMoviesEvent.addToWatchlist(
                                              movie!));
                                    }
                                  } else {
                                    if (isTvShow) {
                                      Provider.of<TvDetailBloc>(context,
                                              listen: false)
                                          .add(
                                              TvDetailEvent.removeFromWatchlist(
                                                  tvShow!));
                                    } else {
                                      Provider.of<DetailMoviesBloc>(context,
                                              listen: false)
                                          .add(DetailMoviesEvent
                                              .removeFromWatchlist(movie!));
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              _showGenres(genres),
                            ),
                            Text(
                              _showDuration(runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final recommendations = isTvShow
                                    ? tvShowRecommendations ?? []
                                    : movieRecommendations ?? [];

                                if (recommendations.isEmpty) {
                                  return Center(
                                      child: Text('No recommendations'));
                                }

                                return Container(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: recommendations.length,
                                    itemBuilder: (context, index) {
                                      final item = recommendations[index];
                                      final poster = isTvShow
                                          ? (item as TvShow).posterPath
                                          : (item as Movie).posterPath;
                                      final id = isTvShow
                                          ? (item as TvShow).id
                                          : (item as Movie).id;

                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              isTvShow
                                                  ? MovieDetailPage.ROUTE_NAME
                                                  : MovieDetailPage.ROUTE_NAME,
                                              arguments: {
                                                'id': id,
                                                'isTvShow': isTvShow,
                                              },
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              key: ValueKey(
                                                  'recommendation_$id'),
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500$poster',
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
