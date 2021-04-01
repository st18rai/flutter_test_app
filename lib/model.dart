class GifResult {
  List<Data> data;

  GifResult({this.data});

  GifResult.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  Images images;

  Data({this.images});

  Data.fromJson(Map<String, dynamic> json) {
    images =
        json['images'] != null ? new Images.fromJson(json['images']) : null;
  }
}

class Images {
  Downsized downsized;

  Images({
    this.downsized,
  });

  Images.fromJson(Map<String, dynamic> json) {
    downsized = json['downsized'] != null
        ? new Downsized.fromJson(json['downsized'])
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
