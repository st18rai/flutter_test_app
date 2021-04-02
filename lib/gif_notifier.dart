import 'package:flutter/material.dart';
import 'package:flutter_test_app/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GifNotifier extends ValueNotifier<List<Data>> {
  GifNotifier() : super(null);

  final String _apiKey = 'n5UNOt8t7Gcn6tOjOmyFBUYxRV8wI00o';
  final String _rating = 'g';
  final String _language = 'en';

  bool _hasMoreGifs = true;
  int _offset = 0;
  int _limit = 5;

  List<Data> _listGifsData;
  bool _loading = false;

  @override
  List<Data> get value => _value;
  List<Data> _value;
  @override
  set value(List<Data> newValue) {
    _value = newValue;
    notifyListeners();
  }

  Future<void> reload(String query) async {
    _listGifsData = <Data>[];
    _offset = 0;
    await httpGetGifs(query, _offset);
  }

  Future<void> getMore(String query) async {
    if (_hasMoreGifs && !_loading) {
      _loading = true;
      await httpGetGifs(query, _offset);
      _loading = false;
    }
  }

  Future<void> httpGetGifs(String query, int offset) async {
    _listGifsData ??= <Data>[];
    int nextOffset = offset;

    String _baseUrl =
        'https://api.giphy.com/v1/gifs/search?api_key=$_apiKey&q=$query&limit=$_limit&offset=$offset&rating=$_rating&lang=$_language';

    while (_hasMoreGifs && (nextOffset - offset) < _limit) {
      http.Response res = await http.get(_baseUrl);
      Map<String, dynamic> jsonDecoded = json.decode(res.body);
      jsonDecoded != null
          ? _listGifsData.addAll(GifResult.fromJson(jsonDecoded).data)
          : _hasMoreGifs = false;
      nextOffset = nextOffset + _limit;
    }

    _offset = nextOffset;
    value = _listGifsData;
  }
}
