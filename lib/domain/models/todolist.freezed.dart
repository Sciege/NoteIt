// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todolist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Todolist {
  dynamic get key => throw _privateConstructorUsedError;
  String get todolist => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isDone => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TodolistCopyWith<Todolist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodolistCopyWith<$Res> {
  factory $TodolistCopyWith(Todolist value, $Res Function(Todolist) then) =
      _$TodolistCopyWithImpl<$Res, Todolist>;
  @useResult
  $Res call({dynamic key, String todolist, String description, bool isDone});
}

/// @nodoc
class _$TodolistCopyWithImpl<$Res, $Val extends Todolist>
    implements $TodolistCopyWith<$Res> {
  _$TodolistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? todolist = null,
    Object? description = null,
    Object? isDone = null,
  }) {
    return _then(_value.copyWith(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as dynamic,
      todolist: null == todolist
          ? _value.todolist
          : todolist // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodolistImplCopyWith<$Res>
    implements $TodolistCopyWith<$Res> {
  factory _$$TodolistImplCopyWith(
          _$TodolistImpl value, $Res Function(_$TodolistImpl) then) =
      __$$TodolistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({dynamic key, String todolist, String description, bool isDone});
}

/// @nodoc
class __$$TodolistImplCopyWithImpl<$Res>
    extends _$TodolistCopyWithImpl<$Res, _$TodolistImpl>
    implements _$$TodolistImplCopyWith<$Res> {
  __$$TodolistImplCopyWithImpl(
      _$TodolistImpl _value, $Res Function(_$TodolistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? todolist = null,
    Object? description = null,
    Object? isDone = null,
  }) {
    return _then(_$TodolistImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as dynamic,
      todolist: null == todolist
          ? _value.todolist
          : todolist // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TodolistImpl implements _Todolist {
  const _$TodolistImpl(
      {this.key,
      required this.todolist,
      required this.description,
      this.isDone = false});

  @override
  final dynamic key;
  @override
  final String todolist;
  @override
  final String description;
  @override
  @JsonKey()
  final bool isDone;

  @override
  String toString() {
    return 'Todolist(key: $key, todolist: $todolist, description: $description, isDone: $isDone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodolistImpl &&
            const DeepCollectionEquality().equals(other.key, key) &&
            (identical(other.todolist, todolist) ||
                other.todolist == todolist) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isDone, isDone) || other.isDone == isDone));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(key), todolist, description, isDone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TodolistImplCopyWith<_$TodolistImpl> get copyWith =>
      __$$TodolistImplCopyWithImpl<_$TodolistImpl>(this, _$identity);
}

abstract class _Todolist implements Todolist {
  const factory _Todolist(
      {final dynamic key,
      required final String todolist,
      required final String description,
      final bool isDone}) = _$TodolistImpl;

  @override
  dynamic get key;
  @override
  String get todolist;
  @override
  String get description;
  @override
  bool get isDone;
  @override
  @JsonKey(ignore: true)
  _$$TodolistImplCopyWith<_$TodolistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
