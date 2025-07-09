import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show_detail.dart';
import 'package:ditonton/tv_show/domain/repositories/tv_repositories.dart';

class SaveWatchList {
  final TvRepositories repositories;

  SaveWatchList(this.repositories);

  Future<Either<Failure, String>> execute(TvShowDetail movie) {
    return repositories.saveWatchlist(movie);
  }
}
