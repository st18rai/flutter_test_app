import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/bloc/gif_event.dart';
import 'package:flutter_test_app/bloc/gif_state.dart';
import 'package:flutter_test_app/gif_provider.dart';
import 'package:flutter_test_app/model.dart';
import 'package:rxdart/rxdart.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final GifProvider gifProvider;

  GifBloc({@required this.gifProvider}) : super(GifInitial());

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
    final currentState = state;

    // print('event: $event');

    if (event is GifSearchPressed) {
      yield GifLoading();

      try {
        if (currentState is GifInitial) {
          final gifs = await _searchGifs(event.query);
          yield GifSuccess(gifs: gifs, hasReachedMax: false);
          return;
        }
        if (currentState is GifSuccess) {
          final gifs = await _searchGifs(event.query);
          // print('initial fetched success: ${gifs.length}');

          yield GifSuccess(gifs: gifs, hasReachedMax: false);
          return;
        }
      } catch (_) {
        yield GifFailure();
      }
    }

    if (event is GifMoreFetched && !_hasReachedMax(currentState)) {
      // print('more fetched state: $currentState');

      try {
        if (currentState is GifSuccess) {
          final gifs = await _loadMore(event.query);
          // print('more fetched success: ${gifs.length}');
          yield gifs.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : GifSuccess(
                  gifs: currentState.gifs + gifs,
                  hasReachedMax: false,
                );
          // print('more fetched state2: $currentState');

          // print('images: ${gifs.toString()}');
          return;
        }
      } catch (_) {
        yield GifFailure();
      }
    }
  }

  bool _hasReachedMax(GifState state) =>
      state is GifSuccess && state.hasReachedMax;

  Future<List<Data>> _searchGifs(String query) async {
    return await gifProvider.reload(query);
  }

  Future<List<Data>> _loadMore(String query) async {
    return await gifProvider.getMore(query);
  }
}
