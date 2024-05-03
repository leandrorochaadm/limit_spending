import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  runApp(
    MaterialApp(
      title: 'Flutter Database Example',
      home: MyHomePage(firestore: firestore),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.firestore});

  final FirebaseFirestore firestore;
  String get collection => 'test';

  @override
  Widget build(BuildContext context) {
    final String dateNow = DateTime.now().toIso8601String();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                firestore
                    .collection('collection')
                    .doc('doc')
                    .set(<String, String>{'date': dateNow});

                debugPrint('test $dateNow');
              },
              child: const Text('create'),
            ),
          ],
        ),
      ),
    );
  }
}
