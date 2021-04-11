import 'package:equatable/equatable.dart';
import 'package:flutter_test_app/model/model.dart';

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

  @override
  List<Object> get props => [gifs];

  @override
  String toString() => 'GifSuccess { gifs: ${gifs.length} }';
}
