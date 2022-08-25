import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:merged_app/fetch_flutter.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'fetch_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return Container();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Widget> pages = [
    HomePage(),
    FetchFlutterPage(),
  ];
  // file grab!!!!!!!!!!!!!!!!!!!!
  void pickFiless() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    Uint8List? fileBites = result.files.first.bytes;

    // conv to bites create from bites
    Directory appDocDir = await getApplicationDocumentsDirectory();
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Manager'),
      ),
      body: pages[currentPage],
      // add in file picker func
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickFiless();
          debugPrint('Floating Action Button');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
