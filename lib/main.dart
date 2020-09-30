import 'package:flutter/material.dart';
import 'package:flutter_connection_poc/screens/dashboard/dashboard.dart';

void main() {
  runApp(ConnectionApp());
}

class ConnectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Dashboard(),
    );
  }
}
