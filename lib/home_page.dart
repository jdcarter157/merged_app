import 'package:merged_app/db_insert.dart';

import 'learn_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const DbInsertPage();
                  },
                ),
              );
            },
            child: const Text('Add Post'),
          ),
          // Text(snapshot.data!.title);
        )
      ],
    );
  }
}
