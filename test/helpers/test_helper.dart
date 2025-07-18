import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/tv_show/data/dataSources/tv_remote_data_source.dart';
import 'package:ditonton/tv_show/domain/repositories/tv_repositories.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  NetworkInfo,
  TvRemoteDataSource,
  TvRepositories
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
