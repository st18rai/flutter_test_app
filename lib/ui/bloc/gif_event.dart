abstract class GifEvent {}

class GifSearchPressedEvent extends GifEvent {
  final String query;

  GifSearchPressedEvent(this.query);
}

class GifMoreFetchedEvent extends GifEvent {
  final String query;

  GifMoreFetchedEvent(this.query);
}
