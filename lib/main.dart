import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/bloc/gif_bloc.dart';
import 'package:flutter_test_app/bloc/gif_event.dart';
import 'package:flutter_test_app/gif_provider.dart';
import 'package:flutter_test_app/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          create: (context) =>
              GifBloc(gifProvider: GifProvider())..add(GifAppStarted()),
          child: HomePage(),
        ),
      ),
    );
  }
}
