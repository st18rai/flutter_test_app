import 'package:equatable/equatable.dart';

class GifResult extends Equatable {
  List<Data> data;

  GifResult({this.data});

  GifResult.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<Data>();
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  @override
  List<Object> get props => [data];
}

class Data {
  Images images;

  Data({this.images});

  Data.fromJson(Map<String, dynamic> json) {
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
  }

  @override
  String toString() {
    return 'Images: ${images.downsized.url}\n';
  }
}

class Images {
  Downsized downsized;

  Images({
    this.downsized,
  });

  Images.fromJson(Map<String, dynamic> json) {
    downsized = json['downsized'] != null
        ? Downsized.fromJson(json['downsized'])
        : null;
  }
}

class Downsized {
  String url;

  Downsized({this.url});

  Downsized.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
