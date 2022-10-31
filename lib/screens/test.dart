import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/services/firestore_database.dart';

class Test extends StatefulWidget {
  static const String id = 'test_screen';
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  StreamController<Stream<QuerySnapshot>> controller = StreamController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: Column(
        children: [
          MaterialButton(onPressed: () {
            Stream stream = controller.stream;
            stream.listen((event) {
              print(event.toString());
            });
          }),
          MaterialButton(onPressed: (() {}))
        ],
      ),
    );
  }
}
