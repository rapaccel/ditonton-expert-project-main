import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/repositories/tv_repositories.dart';

class GetTopRatedTv {
  final TvRepositories tvRepositories;

  GetTopRatedTv(this.tvRepositories);

  Future<Either<Failure, List<TvShow>>> execute() {
    return tvRepositories.getTopRatedTvShows();
  }
}
