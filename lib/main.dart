import 'package:flutter/material.dart';
import 'package:stocks_app/pages/login_page.dart';

// Register the RouteObserver as a navigation observer.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
    App(),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Stocks",
      home: LoginPage(),
      navigatorObservers: [routeObserver],
    );
  }
}
