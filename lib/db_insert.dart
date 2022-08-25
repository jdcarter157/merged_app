import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(
    String title, String author, String image, String text) async {
  final response = await http.post(
    Uri.parse('http://192.168.0.136/cross_plat_sharing/insert.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'author': author,
      'imageurl': image,
      'content': text,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.statusCode);
    print(response.body);

    return Album.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode);
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final String title;
  final String author;
  final String image;
  final String text;

  const Album(
      {required this.title,
      required this.author,
      required this.image,
      required this.text});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
      author: json['author'],
      image: json['image'],
      text: json['text'],
    );
  }
}

class DbInsertPage extends StatefulWidget {
  const DbInsertPage({super.key});

  @override
  State<DbInsertPage> createState() => _DbInsertPageState();
}

class _DbInsertPageState extends State<DbInsertPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'insert Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('insert Data'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Enter Text')),
        TextField(
            controller: _imageController,
            decoration: const InputDecoration(hintText: 'Enter Image URL')),
        TextField(
            controller: _authorController,
            decoration: const InputDecoration(hintText: 'Enter Author')),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(
                  _titleController.text,
                  _textController.text,
                  _imageController.text,
                  _authorController.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        }

        // else if (snapshot.hasError) {
        // return Text('${snapshot.error}');
        // }

        else {
          return const Text('post submitted');
        }

        // return const CircularProgressIndicator();
      },
    );
  }
}
