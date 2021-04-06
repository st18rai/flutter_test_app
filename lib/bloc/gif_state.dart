import 'package:equatable/equatable.dart';
import 'package:flutter_test_app/model.dart';

abstract class GifState extends Equatable {
  const GifState();

  @override
  List<Object> get props => [];
}

class GifInitial extends GifState {}

class GifFailure extends GifState {}

class GifLoading extends GifState {}

class GifLoadingMore extends GifState {}

class GifSuccess extends GifState {
  final List<Data> gifs;
  final bool hasReachedMax;

  const GifSuccess({
    this.gifs,
    this.hasReachedMax,
  });

  GifSuccess copyWith({
    List<Data> gifs,
    bool hasReachedMax,
  }) {
    return GifSuccess(
        gifs: gifs ?? this.gifs,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [gifs, hasReachedMax];

  @override
  String toString() =>
      'GifSuccess { gifs: ${gifs.length}, hasReachedMax: $hasReachedMax }';
}
