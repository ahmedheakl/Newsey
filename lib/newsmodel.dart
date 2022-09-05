class News {
  String? author;
  String? title;
  String? descp;
  String? url;
  String? urlImage;
  String? content;
  String publishedAt = "";
  String? source;

  News.json(Map<String, dynamic> jsonData) {
    author = jsonData['author'] ?? 'unKnown';
    title = jsonData['title'] ?? "-------";
    content = jsonData['content'] ?? "-------";
    descp = jsonData['description'] ?? "-------";
    publishedAt = jsonData['publishedAt'] ?? "-------";
    url = jsonData['url'] ?? "-------";
    urlImage = jsonData['urlToImage'] ??
        "https://thumbs.dreamstime.com/z/no-image-available-icon-photo-camera-flat-vector-illustration-132483141.jpg";
    source = jsonData['source']['name'] ?? "------";
  }
}
