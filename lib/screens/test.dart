import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/services/riverpod.dart';

class Test extends ConsumerWidget {
  static const String id = 'test_screen';
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(builder: (context, ref, child) {
              return ref.read(profileDataProvider).when(data: (String? value) {
                return Text(value!);
              }, error: (error, stackTrace) {
                return const Text("Error");
              }, loading: () {
                return const CircularProgressIndicator();
              });
            }),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Test.id);
                  print('${ref.read(profileDataProvider)}');
                },
                child: const Text('press'))
          ],
        ),
      ),
    );
  }
}
