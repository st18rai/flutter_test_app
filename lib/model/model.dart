import 'package:equatable/equatable.dart';

class GifResult extends Equatable {
  List<Data> data = <Data>[];

  GifResult({required this.data});

  GifResult.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  @override
  List<Object> get props => [data];
}

class Data {
  Images? images;

  Data({required this.images});

  Data.fromJson(Map<String, dynamic> json) {
    images = (json['images'] != null ? Images.fromJson(json['images']) : null)!;
  }

  @override
  String toString() {
    return 'Images: ${images?.downsized?.url}\n';
  }
}

class Images {
  Downsized? downsized;

  Images({
    required this.downsized,
  });

  Images.fromJson(Map<String, dynamic> json) {
    downsized = (json['downsized'] != null
        ? Downsized.fromJson(json['downsized'])
        : null)!;
  }
}

class Downsized {
  late String url;

  Downsized({required this.url});

  Downsized.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
