import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_event.dart';
import 'package:flutter_test_app/gif_ds.dart';
import 'package:flutter_test_app/ui/page/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: close_sinks
  final GifBloc bloc = GifBloc(gifDs: GifDs())..add(GifAppStarted());
  final HomeScreenData screenData = HomeScreenData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Test App'),
        ),
        body: BlocProvider<GifBloc>(
          create: (context) => bloc,
          child: HomeScreen(bloc, screenData),
        ),
      ),
    );
  }
}
