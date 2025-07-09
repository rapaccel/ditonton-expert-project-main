import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/repositories/tv_repositories.dart';

class SearchTvShow {
  final TvRepositories repository;

  SearchTvShow(this.repository);

  Future<Either<Failure, List<TvShow>>> execute(String query) {
    return repository.searchTvShows(query);
  }
}
