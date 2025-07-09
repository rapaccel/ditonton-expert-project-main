import 'package:equatable/equatable.dart';

class TvShow extends Equatable {
  TvShow(
      {required this.id,
      required this.name,
      required this.overview,
      required this.posterPath,
      required this.voteAverage,
      required this.voteCount,
      required this.runtime});

  TvShow.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  int id;
  String name;
  String overview;
  String? posterPath;
  double? voteAverage;
  int? voteCount;
  int? runtime;

  @override
  List<Object?> get props =>
      [id, name, overview, posterPath, voteAverage, voteCount, runtime];
}
