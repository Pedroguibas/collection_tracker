import 'package:collection_tracker/pages/home.dart';
import 'package:flutter/material.dart';

class CollectionTrackerApp extends StatelessWidget {
  const CollectionTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}
