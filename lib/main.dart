import 'package:flutter/material.dart';
import 'package:flutter_test_app/gif_notifier.dart';

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
  GifNotifier _notifier;

  final _textController = TextEditingController();

  @override
  void initState() {
    _notifier = GifNotifier();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    _notifier.dispose();
    super.dispose();
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
        body: SafeArea(
          child: Container(
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
                          controller: _textController,
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
                            _notifier.reload(_textController.text);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ValueListenableBuilder<List<Data>>(
                      valueListenable: _notifier,
                      builder: (BuildContext context, List<Data> value,
                          Widget child) {
                        return value != null
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  return await _notifier
                                      .reload(_textController.text);
                                },
                                child: value.isEmpty
                                    ? ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return const Center(
                                              child: Text('No Gifs!'));
                                        })
                                    : NotificationListener<ScrollNotification>(
                                        onNotification:
                                            (ScrollNotification scrollInfo) {
                                          if (scrollInfo
                                                  is ScrollEndNotification &&
                                              scrollInfo.metrics.extentAfter ==
                                                  0) {
                                            _notifier
                                                .getMore(_textController.text);
                                            return true;
                                          }
                                          return false;
                                        },
                                        child: ListView.separated(
                                            separatorBuilder: (context,
                                                    index) =>
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Divider(),
                                                ),
                                            padding: EdgeInsets.only(top: 20),
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: value.length,
                                            cacheExtent: 5,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Image.network(value[index]
                                                  .images
                                                  .downsized
                                                  .url);
                                            }),
                                      ),
                              )
                            : Center(
                                child: Text(
                                'Start searching gifs!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                ),
                              ));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
