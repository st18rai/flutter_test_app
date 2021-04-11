import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_bloc.dart';
import 'package:flutter_test_app/src/ds_gif.dart';
import 'package:flutter_test_app/ui/page/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // ignore: close_sinks
  final GifBloc bloc = GifBloc(gifDs: GifDs());
  final HomeScreenData screenData = HomeScreenData();

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          create: (context) => widget.bloc,
          child: HomeScreen(widget.bloc, widget.screenData),
        ),
      ),
    );
  }
}
