import 'dart:convert';

import 'package:ditonton/tv_show/data/models/tv_model.dart';
import 'package:ditonton/tv_show/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    adult: false,
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalName: "Original Title",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    name: "Title",
    originalLanguage: "en",
    runtime: 1,
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tTvResponseModel = TvResponse(movieList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/on_air_tv.json'));

      // act
      final result = TvResponse.fromJson(jsonMap);

      // assert
      expect(result.movieList.isNotEmpty, true);
      expect(result.movieList.first, isA<TvModel>());
      expect(result.movieList.first.name, "Late Night with Seth Meyers");
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3, 4],
            "id": 1,
            "original_name": "Original Title",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "name": "Title",
            "original_language": "en",
            "runtime": 1,
            "vote_average": 1.0,
            "vote_count": 1,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
