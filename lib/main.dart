import 'package:flutter/material.dart';
import 'package:sudoku_app/sudoku.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new SudokuApp(),
      //debugShowCheckedModeBanner: false,
      debugShowCheckedModeBanner: false,
    );
  }
}
