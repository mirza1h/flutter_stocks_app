import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/models/news.dart';
import 'package:stocks_app/widgets/news_tile.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<News>> newsList;

  @override
  void initState() {
    newsList = HttpHelper.fetchNews(5);
    super.initState();
  }

  Future<void> onRefresh() async {
    setState(() {
      newsList = HttpHelper.fetchNews(5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: FutureBuilder(
          future: HttpHelper.fetchNews(5),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey);
                },
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final news = snapshot.data[index];
                  return NewsTile(
                      image: news.image,
                      desc: news.text,
                      title: news.title,
                      publishedDate: news.publishedDate,
                      site: news.site,
                      url: news.url);
                },
              );
            } else
              return Container();
          }),
    );
  }
}
