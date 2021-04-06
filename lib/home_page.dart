import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/bloc/gif_bloc.dart';
import 'package:flutter_test_app/bloc/gif_event.dart';
import 'package:flutter_test_app/bloc/gif_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  GifBloc _gifBloc;

  @override
  void initState() {
    super.initState();
    _gifBloc = BlocProvider.of<GifBloc>(context);
  }

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
                        _gifBloc.add(
                            GifSearchPressed()..query = _textController.text);
                        // print('search button');
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<GifBloc, GifState>(builder: (context, state) {
                // print('state: $state');

                if (state is GifLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellowAccent,
                    ),
                  );
                }

                if (state is GifLoadingMore) {
                  return Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: SizedBox(
                        width: 33,
                        height: 33,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),
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
                  // print('gif success');

                  if (state.gifs.isEmpty) {
                    return InfoBox('Nothing found');
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollEndNotification &&
                          scrollInfo.metrics.extentAfter == 0) {
                        // print('load more');
                        _gifBloc.add(
                            GifMoreFetched()..query = _textController.text);

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
                      itemCount: state.gifs.length,
                      cacheExtent: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          state.gifs[index].images.downsized.url,
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
