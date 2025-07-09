import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/tv_show/data/dataSources/tv_remote_data_source.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show_detail.dart';
import 'package:ditonton/tv_show/domain/repositories/tv_repositories.dart';

class TvRepositoriesImpl implements TvRepositories {
  final TvRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TvRepositoriesImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TvShow>>> getOnTheAirTvShows() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getOnTheAirTvShows();
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure('Failed to fetch data from server'));
      } on SocketException {
        return Left(ConnectionFailure('Failed to connect to the network'));
      }
    } else {
      return Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getPopularTvShows() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPopularTvShows();
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure('Failed to fetch data from server'));
      } on SocketException {
        return Left(ConnectionFailure('Failed to connect to the network'));
      }
    } else {
      return Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getTopRatedTvShows() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTopRatedTvShows();
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure('Failed to fetch data from server'));
      } on SocketException {
        return Left(ConnectionFailure('Failed to connect to the network'));
      }
    } else {
      return Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getTvRecommendation(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTvShowRecommendations(id);
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure('Failed to fetch data from server'));
      } on SocketException {
        return Left(ConnectionFailure('Failed to connect to the network'));
      }
    } else {
      return Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> searchTvShows(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.searchTvShows(query);
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      } on SocketException {
        return Left(ConnectionFailure('Failed to connect to the network'));
      }
    } else {
      return Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TvShowDetail>> getTvShowDetail(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTvShowDetail(id);
        return Right(result.toEntity());
      } on ServerException {
        return Left(ServerFailure('Failed to fetch data from server'));
      } on SocketException {
        return Left(ConnectionFailure('Failed to connect to the network'));
      }
    } else {
      return Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvShowDetail movie) async {
    try {
      final result =
          await localDataSource.removeWatchlist(MovieTable.fromTvEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getMovieById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TvShow>>> getWatchlistTv() async {
    final result = await localDataSource.getWatchlistMovies();
    return Right(result.map((data) => data.toTvShowEntity()).toList());
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvShowDetail movie) async {
    try {
      final result =
          await localDataSource.insertWatchlist(MovieTable.fromTvEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }
}
