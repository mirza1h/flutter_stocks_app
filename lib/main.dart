import 'package:flutter/material.dart';
import 'package:stocks_app/pages/login_page.dart';

import 'pages/home_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Stocks",
      home: LoginPage(),
    );
  }
}
