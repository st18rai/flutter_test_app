import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_test_app/ui/bloc/gif_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_state.dart';
import 'package:flutter_test_app/ui/page/home_screen.dart';
import 'package:mockito/mockito.dart';

class MockGifBloc extends Mock implements GifBloc {}

void main() {
  // ignore: close_sinks
  MockGifBloc _bloc;
  HomeScreenData _screenData;

  setUp(() {
    _bloc = MockGifBloc();
    when(_bloc.skip(any)).thenAnswer((_) async* {
      null;
    });
    _screenData = HomeScreenData();
  });

  tearDown(() {
    _bloc.close();
  });

  Future _createWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<GifBloc>(
            create: (context) => _bloc,
            child: HomeScreen(_bloc, _screenData),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('check initial text', (WidgetTester tester) async {
    when(_bloc.state).thenReturn(GifInitialState());

    await _createWidget(tester);

    expect(find.text(_screenData.initialText), findsOneWidget,
        reason: 'Should be: "Start searching gifs!"');

    expect(find.text(_screenData.hintText), findsOneWidget,
        reason: 'Should be: "Enter a search term"');
  });

  testWidgets('check enter search query text', (WidgetTester tester) async {
    when(_bloc.state).thenReturn(GifInitialState());

    final query = 'test';

    await _createWidget(tester);

    await tester.enterText(find.byType(TextField), query);

    expect(find.text(query), findsOneWidget, reason: 'Should be: "test"');
  });

  testWidgets('check error state', (WidgetTester tester) async {
    when(_bloc.state).thenReturn(GifFailureState());

    await _createWidget(tester);

    expect(find.text(_screenData.errorText), findsOneWidget,
        reason: 'Should be: "Something went wrong"');
  });

  testWidgets('check nothing found text', (WidgetTester tester) async {
    when(_bloc.state).thenReturn(GifSuccessState(gifs: [], hasMore: false));

    await _createWidget(tester);

    expect(find.text(_screenData.nothingFoundText), findsOneWidget,
        reason: 'Should be: "Nothing found"');
  });

  // testWidgets('check gifs loaded', (WidgetTester tester) async {
  //   _screenData.gifs = <Data>[
  //     Data(
  //         images: Images(
  //             downsized: Downsized(
  //                 url:
  //                     'https://media2.giphy.com/media/8ByB3sXbFcmpxzz3s0/giphy.gif?cid=ecf05e47b02kvbmyxrztqf449a5pb2t0jqxjvn2hquo7qoim&rid=giphy.gif&ct=g'))),
  //   ];
  //
  //   when(_bloc.state)
  //       .thenReturn(GifSuccessState(gifs: _screenData.gifs, hasMore: true));
  //
  //   await _createWidget(tester);
  //
  //   expect(find.byType(ListView), findsOneWidget,
  //       reason: 'Should be: listView with gifs');
  // });
}
