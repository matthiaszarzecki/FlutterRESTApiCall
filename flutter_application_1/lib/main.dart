import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class House {
  final String name;
  final String region;
  final String coatOfArms;

  const House({
    required this.name,
    required this.region,
    required this.coatOfArms,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      name: json['name'],
      region: json['region'],
      coatOfArms: json['coatOfArms'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Houses of Westeros',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Houses of Westeros'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<House> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  void _incrementCounter() {
    setState(() {
      futureAlbum = fetchAlbum();
    });
  }

  Future<House> fetchAlbum() async {
    var numberOfHouses = 444;
    var randomNumber = Random().nextInt(numberOfHouses);

    final response = await http.get(
        Uri.parse('https://anapioficeandfire.com/api/houses/$randomNumber'));

    if (response.statusCode == 200) {
      return House.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<House>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    snapshot.data!.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(snapshot.data!.region),
                  Text("🛡️ ${snapshot.data!.coatOfArms.toString()}"),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Refresh',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
