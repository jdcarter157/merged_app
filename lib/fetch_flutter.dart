import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// connecting to the api endpoint
Future<List<Album>> fetchAlbum() async {
  var url = 'http://192.168.0.140/cross_plat_sharing/flutter_share.php';
  // "http://10.0.0.233/cross_plat_sharing/flutter_share.php"

  final response = await http.post(Uri.parse(url));
  // print(response.body);
  // return compute(parseAlbums, response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable l = json.decode(response.body);
    return List<Album>.from(l.map((model) => Album.fromJson(model)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

List<Album> parseAlbums(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}
// Future getPostInfo() async {
//     var id = await const PostInfo().id;
//     var url = 'http://192.168.0.136/cross_plat_sharing/flutter_share.php';
//     var response = await http.post(Uri.parse(url), body: json.encode(Album));
//     Map<String, dynamic> data =
//         Map<String, dynamic>.from(json.decode(response.body));
//     log(data.toString());
//     setState(() {
//       title = data['title'];
//     });
// }

class Album {
  final int id;
  final String title;
  final String created;
  final String imageurl;

  const Album({
    required this.id,
    required this.title,
    required this.created,
    required this.imageurl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    // print(json);
    // print("${json['id']} ${json['title']} ${json['created']} ${json['imageurl']}");
    return Album(
      // building album from json keys
      id: json['id'],
      title: json['title'],
      created: json['created'],
      imageurl: json['imageurl'] ??
          'https://images.pexels.com/photos/949592/pexels-photo-949592.jpeg?cs=srgb&dl=pexels-rovenimagescom-949592.jpg&fm=jpg',
    );
    // /if imageurl is null use default image url
  }
}

class FetchFlutterPage extends StatefulWidget {
  const FetchFlutterPage({super.key});

  @override
  State<FetchFlutterPage> createState() => _FetchFlutterPageState();
}

class _FetchFlutterPageState extends State<FetchFlutterPage> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: FutureBuilder<List<Album>>(
          future: futureAlbum,
          builder: (context, snapshot) {
            // if json is ready return list of post(albums)
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    // display data pulled from db
                    children: [
                      Text(snapshot.data![index].title),
                      Text(snapshot.data![index].created),
                      snapshot.data![index].imageurl == ''
                          ? Text('No Album Art')
                          : Image.network(snapshot.data![index].imageurl),
                      // Image.network(
                      //     'https://i.pinimg.com/736x/aa/fc/82/aafc8273fdf09f9a98f8127052e24cb7.jpg'),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error} WHAHWHAHA');
            }

            //show a loading spinner
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
