import 'package:flutter/cupertino.dart';
import 'package:flutter_test_app/model/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GifDs {
  final String _baseUrl = 'https://api.giphy.com/v1/gifs/search';
  final String _apiKey = 'n5UNOt8t7Gcn6tOjOmyFBUYxRV8wI00o';
  final String _rating = 'g';
  final String _language = 'en';

  Future<List<Data>> httpGetGifs({
    required String query,
    required int offset,
    int limit = 5,
  }) async {
    List<Data> listGifsData = <Data>[];

    String url =
        '$_baseUrl?api_key=$_apiKey&q=$query&limit=$limit&offset=$offset&rating=$_rating&lang=$_language';

    http.Response res = await http.get(url);
    Map<String, dynamic> jsonDecoded = json.decode(res.body);
    if (jsonDecoded != null) {
      listGifsData.clear();
      listGifsData.addAll(GifResult.fromJson(jsonDecoded).data);
    }

    return listGifsData;
  }
}
