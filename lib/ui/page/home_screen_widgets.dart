import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  LoadingWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: color,
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final String text;
  InfoWidget(this.text);

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
