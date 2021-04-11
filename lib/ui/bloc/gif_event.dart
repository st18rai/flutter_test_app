import 'package:equatable/equatable.dart';

abstract class GifEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GifSearchPressed extends GifEvent {
  final String query;

  GifSearchPressed(this.query);
}

class GifMoreFetched extends GifEvent {
  final String query;
  final bool hasMore;

  GifMoreFetched(this.query, this.hasMore);
}
