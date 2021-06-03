import 'package:equatable/equatable.dart';
import 'package:flutter_test_app/model/model.dart';

abstract class GifState extends Equatable {
  const GifState();

  @override
  List<Object> get props => [];
}

class GifInitialState extends GifState {}

class GifFailureState extends GifState {}

class GifLoadingState extends GifState {}

class GifSuccessState extends GifState {
  final List<Data> gifs;
  final bool hasMore;

  const GifSuccessState({required this.gifs, required this.hasMore});

  @override
  List<Object> get props => [gifs, hasMore];
}
