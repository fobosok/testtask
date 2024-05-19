// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_application_2/photo_grid.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Unsplash imgs'),
        ),
        body: const PhotoGrid(),
      ),
    );
  }
}
