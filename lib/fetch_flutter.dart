import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ISHHHH
// Future getUserInfo() async {
//     var user = await const User().getUser();
//     var url = 'https://16c9-108-36-126-67.ngrok.io/userinfo';
//     var response = await http.post(Uri.parse(url), body: json.encode(user));
//     Map<String, dynamic> data =
//         Map<String, dynamic>.from(json.decode(response.body));
//     log(data.toString());
//     setState(() {
//       name = data['first_name'];
//     });
//   }

Future<List<Album>> fetchAlbum() async {
  var url = 'http://192.168.0.136/cross_plat_sharing/flutter_share.php';

  final response = await http.post(Uri.parse(url));
  // print(response.body);
  // return compute(parseAlbums, response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // return <List<Album>>().fromJson(jsonDecode(response.body));
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
    print(json);
    print(
        "${json['id']} ${json['title']} ${json['created']} ${json['imageurl']}");
    return Album(
      id: json['id'],
      title: json['title'],
      created: json['created'],
      imageurl: json['imageurl'] ??
          'https://images.pexels.com/photos/949592/pexels-photo-949592.jpeg?cs=srgb&dl=pexels-rovenimagescom-949592.jpg&fm=jpg',
    );
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
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Column(
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
              // for (int i = 0; i < 10; i++) {
              //   // loop thru snapshot.data and
              //   // set var data= snapshot.data[i]
              //   // newvar=i
              //   var data = snapshot.data![i];
              //   print(data);
              //   return Column(
              //     children: [
              //       // Text('${data}'),
              //     ],
              //   );
              // }
              // ;

            } else if (snapshot.hasError) {
              return Text('${snapshot.error} WHAHWHAHA');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
