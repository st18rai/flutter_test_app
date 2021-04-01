import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api_helper.dart';

import 'dart:async';

import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<GifResult> _futureGif;

  final _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Widget _buildListView(List data) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: data[index].images.downsized.url,
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        );
      },
    );
  }

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
        body: Container(
          color: Colors.teal,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter a search term'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      height: 58,
                      color: Colors.yellow,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _futureGif = ApiHelper().fetchGifs(_controller.text);
                        });
                      },
                    ),
                  ),
                ],
              ),
              FutureBuilder<GifResult>(
                future: _futureGif,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: _buildListView(snapshot.data.data),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
