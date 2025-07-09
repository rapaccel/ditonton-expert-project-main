import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show_detail.dart';
import 'package:ditonton/tv_show/domain/repositories/tv_repositories.dart';

class GetTvDetail {
  final TvRepositories repository;

  GetTvDetail(this.repository);

  Future<Either<Failure, TvShowDetail>> execute(int id) {
    return repository.getTvShowDetail(id);
  }
}
