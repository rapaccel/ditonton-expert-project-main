// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_movies_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ListMoviesEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchAll,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FetchAll value) fetchAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FetchAll value)? fetchAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FetchAll value)? fetchAll,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListMoviesEventCopyWith<$Res> {
  factory $ListMoviesEventCopyWith(
          ListMoviesEvent value, $Res Function(ListMoviesEvent) then) =
      _$ListMoviesEventCopyWithImpl<$Res, ListMoviesEvent>;
}

/// @nodoc
class _$ListMoviesEventCopyWithImpl<$Res, $Val extends ListMoviesEvent>
    implements $ListMoviesEventCopyWith<$Res> {
  _$ListMoviesEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListMoviesEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FetchAllImplCopyWith<$Res> {
  factory _$$FetchAllImplCopyWith(
          _$FetchAllImpl value, $Res Function(_$FetchAllImpl) then) =
      __$$FetchAllImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchAllImplCopyWithImpl<$Res>
    extends _$ListMoviesEventCopyWithImpl<$Res, _$FetchAllImpl>
    implements _$$FetchAllImplCopyWith<$Res> {
  __$$FetchAllImplCopyWithImpl(
      _$FetchAllImpl _value, $Res Function(_$FetchAllImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListMoviesEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchAllImpl implements _FetchAll {
  const _$FetchAllImpl();

  @override
  String toString() {
    return 'ListMoviesEvent.fetchAll()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchAllImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchAll,
  }) {
    return fetchAll();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchAll,
  }) {
    return fetchAll?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchAll,
    required TResult orElse(),
  }) {
    if (fetchAll != null) {
      return fetchAll();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FetchAll value) fetchAll,
  }) {
    return fetchAll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FetchAll value)? fetchAll,
  }) {
    return fetchAll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FetchAll value)? fetchAll,
    required TResult orElse(),
  }) {
    if (fetchAll != null) {
      return fetchAll(this);
    }
    return orElse();
  }
}

abstract class _FetchAll implements ListMoviesEvent {
  const factory _FetchAll() = _$FetchAllImpl;
}

/// @nodoc
mixin _$ListMoviesState {
  List<Movie> get nowPlaying => throw _privateConstructorUsedError;
  List<Movie> get popular => throw _privateConstructorUsedError;
  List<Movie> get topRated => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ListMoviesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListMoviesStateCopyWith<ListMoviesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListMoviesStateCopyWith<$Res> {
  factory $ListMoviesStateCopyWith(
          ListMoviesState value, $Res Function(ListMoviesState) then) =
      _$ListMoviesStateCopyWithImpl<$Res, ListMoviesState>;
  @useResult
  $Res call(
      {List<Movie> nowPlaying,
      List<Movie> popular,
      List<Movie> topRated,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$ListMoviesStateCopyWithImpl<$Res, $Val extends ListMoviesState>
    implements $ListMoviesStateCopyWith<$Res> {
  _$ListMoviesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListMoviesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nowPlaying = null,
    Object? popular = null,
    Object? topRated = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      nowPlaying: null == nowPlaying
          ? _value.nowPlaying
          : nowPlaying // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      popular: null == popular
          ? _value.popular
          : popular // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      topRated: null == topRated
          ? _value.topRated
          : topRated // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListMoviesStateImplCopyWith<$Res>
    implements $ListMoviesStateCopyWith<$Res> {
  factory _$$ListMoviesStateImplCopyWith(_$ListMoviesStateImpl value,
          $Res Function(_$ListMoviesStateImpl) then) =
      __$$ListMoviesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Movie> nowPlaying,
      List<Movie> popular,
      List<Movie> topRated,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$ListMoviesStateImplCopyWithImpl<$Res>
    extends _$ListMoviesStateCopyWithImpl<$Res, _$ListMoviesStateImpl>
    implements _$$ListMoviesStateImplCopyWith<$Res> {
  __$$ListMoviesStateImplCopyWithImpl(
      _$ListMoviesStateImpl _value, $Res Function(_$ListMoviesStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListMoviesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nowPlaying = null,
    Object? popular = null,
    Object? topRated = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$ListMoviesStateImpl(
      nowPlaying: null == nowPlaying
          ? _value._nowPlaying
          : nowPlaying // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      popular: null == popular
          ? _value._popular
          : popular // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      topRated: null == topRated
          ? _value._topRated
          : topRated // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ListMoviesStateImpl implements _ListMoviesState {
  const _$ListMoviesStateImpl(
      {final List<Movie> nowPlaying = const [],
      final List<Movie> popular = const [],
      final List<Movie> topRated = const [],
      this.isLoading = false,
      this.error})
      : _nowPlaying = nowPlaying,
        _popular = popular,
        _topRated = topRated;

  final List<Movie> _nowPlaying;
  @override
  @JsonKey()
  List<Movie> get nowPlaying {
    if (_nowPlaying is EqualUnmodifiableListView) return _nowPlaying;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nowPlaying);
  }

  final List<Movie> _popular;
  @override
  @JsonKey()
  List<Movie> get popular {
    if (_popular is EqualUnmodifiableListView) return _popular;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popular);
  }

  final List<Movie> _topRated;
  @override
  @JsonKey()
  List<Movie> get topRated {
    if (_topRated is EqualUnmodifiableListView) return _topRated;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRated);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'ListMoviesState(nowPlaying: $nowPlaying, popular: $popular, topRated: $topRated, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListMoviesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._nowPlaying, _nowPlaying) &&
            const DeepCollectionEquality().equals(other._popular, _popular) &&
            const DeepCollectionEquality().equals(other._topRated, _topRated) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nowPlaying),
      const DeepCollectionEquality().hash(_popular),
      const DeepCollectionEquality().hash(_topRated),
      isLoading,
      error);

  /// Create a copy of ListMoviesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListMoviesStateImplCopyWith<_$ListMoviesStateImpl> get copyWith =>
      __$$ListMoviesStateImplCopyWithImpl<_$ListMoviesStateImpl>(
          this, _$identity);
}

abstract class _ListMoviesState implements ListMoviesState {
  const factory _ListMoviesState(
      {final List<Movie> nowPlaying,
      final List<Movie> popular,
      final List<Movie> topRated,
      final bool isLoading,
      final String? error}) = _$ListMoviesStateImpl;

  @override
  List<Movie> get nowPlaying;
  @override
  List<Movie> get popular;
  @override
  List<Movie> get topRated;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of ListMoviesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListMoviesStateImplCopyWith<_$ListMoviesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
