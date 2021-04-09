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

class GifSuccess extends GifState {
  final List<Data> gifs;

  const GifSuccess({
    this.gifs,
  });

  GifSuccess copyWith({
    List<Data> gifs,
    bool hasReachedMax,
  }) {
    return GifSuccess(gifs: gifs ?? this.gifs);
  }

  @override
  List<Object> get props => [gifs];

  @override
  String toString() => 'GifSuccess { gifs: ${gifs.length} }';
}
