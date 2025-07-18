import 'dart:convert';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/tv_show/data/models/tv_detail_model.dart';
import 'package:ditonton/tv_show/data/models/tv_model.dart';
import 'package:ditonton/tv_show/data/models/tv_response.dart';
import 'package:http/io_client.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getOnTheAirTvShows();
  Future<List<TvModel>> getPopularTvShows();
  Future<List<TvModel>> getTopRatedTvShows();
  Future<TvDetailResponse> getTvShowDetail(int id);
  Future<List<TvModel>> getTvShowRecommendations(int id);
  Future<List<TvModel>> searchTvShows(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final IOClient ioClient;
  TvRemoteDataSourceImpl({required this.ioClient});

  @override
  Future<List<TvModel>> getOnTheAirTvShows() async {
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvShows() async {
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvShows() async {
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvShowRecommendations(int id) async {
    final response = await ioClient
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvShows(String query) async {
    final response = await ioClient
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvShowDetail(int id) async {
    final response = await ioClient.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
