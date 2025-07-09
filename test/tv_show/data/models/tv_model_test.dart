import 'package:ditonton/tv_show/data/models/tv_model.dart';
import 'package:ditonton/tv_show/domain/entities/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvShowModel = TvModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    originalLanguage: "en",
    runtime: 1,
    name: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvShow = TvShow(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    runtime: 1,
    name: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Tv entity', () async {
    final result = tTvShowModel.toEntity();
    expect(result, tTvShow);
  });
}
