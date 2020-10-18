import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stocks_app/pages/portfolio_page.dart';
import 'package:stocks_app/pages/watchlist_page.dart';
import 'package:stocks_app/widgets/stock_search.dart';
import 'package:stocks_app/widgets/sign_in.dart';

import 'login_page.dart';
import 'news_page.dart';
import 'portfolio_page.dart';
import 'watchlist_page.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State {
  User user;
  int _selectedIndex = 1;

  _HomePageState(User user) {
    this.user = user;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pages = [News(), Watchlist(), Portfolio()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amber[800],
            ),
            accountName: Text("${user.displayName}"),
            accountEmail: Text("${user.email}"),
            currentAccountPicture: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.amber,
              child: Image.network(
                user.photoURL,
              ),
            ),
          ),
          ListTile(
            title: Text("Log out"),
            trailing: Icon(Icons.logout),
            onTap: () {
              signOutGoogle();
              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(pageBuilder: (BuildContext context,
                      Animation animation, Animation secondaryAnimation) {
                    return LoginPage();
                  }, transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return new SlideTransition(
                      position: new Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }),
                  (Route route) => false);
            },
          )
        ]),
      ),
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
