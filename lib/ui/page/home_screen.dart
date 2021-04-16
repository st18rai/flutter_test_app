import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_bloc.dart';
import 'package:flutter_test_app/ui/bloc/gif_event.dart';
import 'package:flutter_test_app/ui/bloc/gif_state.dart';

import '../../model/model.dart';
import 'home_screen_widgets.dart';

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
    return BlocListener<GifBloc, GifState>(
      listener: (context, state) {
        if (state is GifSuccessState) {
          // print(
          //     'Home: screenData gifs before add = ${widget.screenData.gifs.length}');
          widget.screenData.gifs.addAll(state.gifs);
          widget.screenData.hasMore = state.hasMore;
        }
      },
      child: SafeArea(
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
                            hintText: widget.screenData.hintText),
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
                        widget.screenData.gifs.clear();
                        widget.screenData.query = _textController.text;
                        // print(
                        //     'Home: screenData query = ${widget.screenData.query}');
                        widget.bloc.add(
                            GifSearchPressedEvent(widget.screenData.query));
                        // print('Home: search button');
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child:
                    BlocBuilder<GifBloc, GifState>(builder: (context, state) {
                  // print('Home: state = $state');

                  if (state is GifLoadingState) {
                    return LoadingWidget(Colors.yellowAccent);
                  }

                  if (state is GifFailureState) {
                    return InfoWidget(widget.screenData.errorText);
                  }

                  if (state is GifInitialState) {
                    return InfoWidget(widget.screenData.initialText);
                  }

                  // print('Home: gif success');

                  if (widget.screenData.gifs.isEmpty) {
                    return InfoWidget(widget.screenData.nothingFoundText);
                  }

                  // print(
                  //     'Home: screenData gifs after add = ${widget.screenData.gifs.length}');
                  // print('Home: state gifs = ${state.gifs.length}');

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollEndNotification &&
                          scrollInfo.metrics.extentAfter == 0) {
                        // print('Home: load more');
                        widget.bloc
                            .add(GifMoreFetchedEvent(widget.screenData.query));

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
                      itemCount: widget.screenData.hasMore
                          ? widget.screenData.gifs.length + 1
                          : widget.screenData.gifs.length,
                      cacheExtent: 5,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == widget.screenData.gifs.length &&
                            widget.screenData.hasMore) {
                          return LoadingWidget(Colors.white);
                        } else {
                          return Image.network(
                            widget.screenData.gifs[index].images.downsized.url,
                            loadingBuilder: (context, widget, imageChunkEvent) {
                              return imageChunkEvent == null
                                  ? widget
                                  : LoadingWidget(Colors.yellowAccent);
                            },
                          );
                        }
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
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

class HomeScreenData {
  final String hintText = 'Enter a search term';
  final String nothingFoundText = 'Nothing found';
  final String initialText = 'Start searching gifs!';
  final String errorText = 'Something went wrong';

  String query;
  List<Data> gifs = <Data>[];
  bool hasMore = true;
}
