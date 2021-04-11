import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_event.dart';
import 'package:flutter_test_app/ui/bloc/gif_state.dart';
import 'package:flutter_test_app/src/ds_gif.dart';
import 'package:flutter_test_app/model/model.dart';
import 'package:rxdart/rxdart.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final GifDs gifDs;
  int _offset = 0;
  int _limit = 5;

  GifBloc({@required this.gifDs}) : super(GifInitial());

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
    // print('Bloc: event = $event');

    if (event is GifSearchPressed) {
      yield GifLoading();

      try {
        _offset = 0;
        final gifs = await _getGifs(event.query, _offset, _limit);
        yield GifSuccess(gifs: gifs);
        // print('Bloc: initial fetched success: ${gifs.length}');

        return;
      } catch (_) {
        yield GifFailure();
      }
    }

    if (event is GifMoreFetched) {
      // print('Bloc: more fetched state: $currentState');

      try {
        if (event.hasMore) {
          _offset = _offset + _limit;

          final gifs = await _getGifs(event.query, _offset, _limit);
          // print('Bloc: more fetched success: ${gifs.length}');
          yield GifSuccess(gifs: gifs);
          // print('Bloc: offset: $_offset');

          // print('images: ${gifs.toString()}');
        }
        return;
      } catch (e) {
        // print('Bloc: Failure is: + $e');
        yield GifFailure();
      }
    }
  }

  Future<List<Data>> _getGifs(String query, int offset, int limit) async {
    return await gifDs.httpGetGifs(query: query, offset: offset, limit: limit);
  }
}
