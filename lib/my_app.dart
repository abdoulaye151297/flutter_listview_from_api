import 'package:flutter/material.dart';
import 'home.dart';

class MonApp extends StatelessWidget {
  const MonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Store",
      home: MyHome(key: Key("MonApp")),
    );
  }
}
