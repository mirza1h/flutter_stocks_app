import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stocks_app/pages/portfolio_page.dart';
import 'package:stocks_app/pages/watchlist_page.dart';
import 'package:stocks_app/widgets/stock_search.dart';

import 'news_page.dart';
import 'portfolio_page.dart';
import 'watchlist_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pages = [News(), Watchlist(), Portfolio()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: Text("Stocks App"),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () =>
                  {showSearch(context: context, delegate: StockSearch())})
        ],
      ),
      body: this._pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.newspaper),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Watchlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "My portfolio",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
