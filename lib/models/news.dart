class News {
  final String publishedDate;
  final String title;
  final String image;
  final String site;
  final String url;
  final String text;

  News(
      {this.publishedDate,
      this.title,
      this.image,
      this.site,
      this.url,
      this.text});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        publishedDate: json['publishedDate'],
        title: json['title'],
        image: json['image'],
        site: json['site'],
        url: json['url'],
        text: json['text']);
  }
}
