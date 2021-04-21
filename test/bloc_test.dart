import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/model/model.dart';
import 'package:flutter_test_app/src/ds_gif.dart';
import 'package:flutter_test_app/ui/bloc/gif_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_event.dart';
import 'package:flutter_test_app/ui/bloc/gif_state.dart';
import 'package:mockito/mockito.dart';

class MockGifDs extends Mock implements GifDs {}

void main() {
  GifBloc bloc;
  MockGifDs gifDs;

  final List<Data> testGifs = <Data>[
    Data(
      images: Images(
        downsized: Downsized(url: 'test.com/image'),
      ),
    ),
  ];

  setUp(() {
    gifDs = MockGifDs();
    bloc = GifBloc(gifDs: gifDs);
  });

  tearDown(() {
    bloc.close();
  });

  group('init bloc tests', () {
    test('check init state pass', () {
      expect(bloc.state, GifInitialState());
    });

    test('close does not emit new states', () {
      expectLater(
        bloc,
        emitsInOrder([GifInitialState(), emitsDone]),
      );
      bloc.close();
    });
  });

  group('search pressed tests', () {
    test('check success state when search pressed', () {
      final query = '123';
      final offset = 0;

      when(gifDs.httpGetGifs(query: query, offset: offset))
          .thenAnswer((_) async => testGifs);

      bloc.add(GifSearchPressedEvent(query));

      expectLater(
        bloc,
        emitsInOrder([
          GifInitialState(),
          GifLoadingState(),
          GifSuccessState(gifs: testGifs, hasMore: true)
        ]),
      );
    });

    test('check failure state when search pressed', () {
      final query = '';
      final offset = 0;

      when(gifDs.httpGetGifs(query: query, offset: offset))
          .thenThrow(Exception());

      bloc.add(GifSearchPressedEvent(query));

      expectLater(
        bloc,
        emitsInOrder([GifInitialState(), GifLoadingState(), GifFailureState()]),
      );
    });
  });

  group('load more tests', () {
    test('check success state when load more', () {
      final query = '123';
      final offset = 5;

      when(gifDs.httpGetGifs(query: query, offset: offset))
          .thenAnswer((_) async => testGifs);

      bloc.add(GifMoreFetchedEvent(query));

      expectLater(
        bloc,
        emitsInOrder([
          GifInitialState(),
          GifSuccessState(gifs: testGifs, hasMore: true)
        ]),
      );
    });

    test('check failure state when load more', () {
      final query = '123';
      final offset = 5;

      when(gifDs.httpGetGifs(query: query, offset: offset))
          .thenThrow(Exception());

      bloc.add(GifMoreFetchedEvent(query));

      expectLater(
        bloc,
        emitsInOrder([GifInitialState(), GifFailureState()]),
      );
    });
  });
}
