import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'category_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                firestore.collection('categories').doc('mercado').set(
                      CategoryModel(
                              name: 'mercado',
                              created: DateTime.now(),
                              limitMonthly: 400,
                              id: '1',
                              consumed: 84)
                          .toJson(),
                    );
              },
              child: const Text('create'),
            ),
          ],
        ),
      ),
    );
  }
}
