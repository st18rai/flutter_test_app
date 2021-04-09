import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_event.dart';
import 'package:flutter_test_app/ui/bloc/gif_state.dart';

import '../../model.dart';

class HomeScreen extends StatefulWidget {
  final GifBloc bloc;
  final HomeScreenData screenData;

  HomeScreen(this.bloc, this.screenData);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                        widget.screenData.gifs.clear();
                        widget.screenData.hasMore = true;
                        widget.screenData.query = _textController.text;
                        // print(
                        //     'Home: before search gifs = ${widget.screenData.gifs.length}');
                        print(
                            'Home: screenData query = ${widget.screenData.query}');
                        widget.bloc
                            .add(GifSearchPressed(widget.screenData.query));
                        print('Home: search button');
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<GifBloc, GifState>(builder: (context, state) {
                print('Home: state = $state');

                if (state is GifLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellowAccent,
                    ),
                  );
                }

                if (state is GifFailure) {
                  return InfoBox('Something went wrong');
                }

                if (state is GifInitial) {
                  return InfoBox('Start searching gifs!');
                }

                if (state is GifSuccess) {
                  // print('Home: gif success');

                  print(
                      'Home: screenData gifs before add = ${widget.screenData.gifs.length}');
                  widget.screenData.gifs.addAll(state.gifs);

                  if (widget.screenData.gifs.isEmpty) {
                    widget.screenData.hasMore = false;
                    return InfoBox('Nothing found');
                  }

                  print(
                      'Home: screenData gifs after add = ${widget.screenData.gifs.length}');
                  // print('Home: state gifs = ${state.gifs.length}');

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollEndNotification &&
                          scrollInfo.metrics.extentAfter == 0) {
                        print('Home: load more');
                        widget.bloc.add(GifMoreFetched(widget.screenData.query,
                            widget.screenData.hasMore));

                        return true;
                      }
                      return false;
                    },
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      padding: EdgeInsets.only(top: 10),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widget
                          .screenData.gifs.length, // change when gifs added
                      cacheExtent: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          widget.screenData.gifs[index].images.downsized.url,
                          loadingBuilder: (context, widget, imageChunkEvent) {
                            return imageChunkEvent == null
                                ? widget
                                : Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.yellowAccent,
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  );
                }
                return InfoBox('Start searching gifs!');
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class InfoBox extends StatelessWidget {
  final String text;
  InfoBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
        ),
      ),
    );
  }
}

class HomeScreenData {
  String query;
  List<Data> gifs = <Data>[];
  bool hasMore = true;
}
