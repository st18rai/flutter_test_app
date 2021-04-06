import 'package:equatable/equatable.dart';

abstract class GifEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GifAppStarted extends GifEvent {}

class GifSearchPressed extends GifEvent {
  String _query;

  String get query => _query;

  set query(String value) {
    _query = value;
  }
}

class GifMoreFetched extends GifEvent {
  String _query;

  String get query => _query;

  set query(String value) {
    _query = value;
  }
}
