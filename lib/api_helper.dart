import 'dart:convert';

import 'model.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  final String apiKey = 'n5UNOt8t7Gcn6tOjOmyFBUYxRV8wI00o';
  final String rating = 'g';
  final String language = 'en';

  Future<GifResult> fetchGifs(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.giphy.com/v1/gifs/search?api_key=$apiKey&q=$query&rating=$rating&lang=$language'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GifResult.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
}
