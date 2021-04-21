import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_event.dart';
import 'package:flutter_test_app/ui/bloc/gif_state.dart';
import 'package:flutter_test_app/src/ds_gif.dart';
import 'package:rxdart/rxdart.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final GifDs gifDs;

  int _offset = 0;
  int _limit = 5;
  bool _hasMore = true;

  GifBloc({@required this.gifDs}) : super(GifInitialState());

  @override
  Stream<Transition<GifEvent, GifState>> transformEvents(
    Stream<GifEvent> events,
    TransitionFunction<GifEvent, GifState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<GifState> mapEventToState(GifEvent event) async* {
    if (event is GifSearchPressedEvent) {
      yield GifLoadingState();

      try {
        _hasMore = true;
        _offset = 0;

        final gifs = await gifDs.httpGetGifs(
            query: event.query, offset: _offset, limit: _limit);

        if (gifs.isEmpty) {
          _hasMore = false;
        }

        yield GifSuccessState(gifs: gifs, hasMore: _hasMore);

        return;
      } catch (_) {
        yield GifFailureState();
      }
    }

    if (event is GifMoreFetchedEvent) {
      try {
        if (_hasMore) {
          _offset = _offset + _limit;

          final gifs = await gifDs.httpGetGifs(
              query: event.query, offset: _offset, limit: _limit);

          if (gifs.isEmpty) {
            _hasMore = false;
          }

          yield GifSuccessState(gifs: gifs, hasMore: _hasMore);
        }
        return;
      } catch (e) {
        yield GifFailureState();
      }
    }
  }
}
