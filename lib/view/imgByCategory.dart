import 'package:flutter/material.dart';

class MyImgCategory extends StatefulWidget {
  const MyImgCategory({super.key});

  @override
  State<MyImgCategory> createState() => _MyImgCategoryState();
}

class _MyImgCategoryState extends State<MyImgCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Category"),
        backgroundColor: Colors.amber,
      ),
    );
  }
}