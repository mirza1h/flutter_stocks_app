import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/widgets/news_tile.dart';

class News extends StatelessWidget {
  const News({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                    url: news.url);
              },
            );
          } else
            return Container();
        });
  }
}
