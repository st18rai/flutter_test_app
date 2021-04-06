import 'package:flutter_test_app/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GifProvider {
  final String _apiKey = 'n5UNOt8t7Gcn6tOjOmyFBUYxRV8wI00o';
  final String _rating = 'g';
  final String _language = 'en';

  int _offset = 0;
  int _limit = 5;

  Future<List<Data>> reload(String query) async {
    _offset = 0;
    return await httpGetGifs(query, _offset);
  }

  Future<List<Data>> getMore(String query) async {
    return await httpGetGifs(query, _offset);
  }

  Future<List<Data>> httpGetGifs(String query, int offset) async {
    List<Data> _listGifsData = <Data>[];
    int nextOffset = offset;

    String _baseUrl =
        'https://api.giphy.com/v1/gifs/search?api_key=$_apiKey&q=$query&limit=$_limit&offset=$offset&rating=$_rating&lang=$_language';

    while (nextOffset - offset < _limit) {
      http.Response res = await http.get(_baseUrl);
      Map<String, dynamic> jsonDecoded = json.decode(res.body);
      if (jsonDecoded != null) {
        _listGifsData.clear();
        _listGifsData.addAll(GifResult.fromJson(jsonDecoded).data);
      }
      nextOffset = nextOffset + _limit;
    }

    _offset = nextOffset;

    return _listGifsData;
  }
}
