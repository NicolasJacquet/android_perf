import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Android perf test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Android perf test'),
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
  String elapsedTime = '0';
  String itemLength = '0';
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Call took : $elapsedTime sec',
                    textAlign: TextAlign.center),
                Text('For $itemLength documents', textAlign: TextAlign.center),
                const SizedBox(height: 40),
                ElevatedButton(
                  child: const Text('Test load with 10 fields'),
                  onPressed: () => testThis('products10'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const Text('Test load with 50 fields'),
                  onPressed: () => testThis('products50'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const Text('Test load with 10 fields and orderBy'),
                  onPressed: () => testThis('products10'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const Text('Test load with 50 fields and orderBy'),
                  onPressed: () => testThis('products50'),
                ),
              ],
            ),
            if (loading)
              Container(
                color: Colors.white.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> testThis(String collectionName, {bool withOrder = false}) async {
    setState(() {
      loading = true;
    });
    print('Test start with $collectionName');
    Stopwatch stopwatch = Stopwatch()..start();

    if (withOrder) {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .orderBy('ein', descending: true)
          .orderBy('name')
          .orderBy('language')
          .orderBy('company')
          .get()
          .then(
            (value) => setLength(value.docs.length),
          );
    } else {
      await FirebaseFirestore.instance.collection(collectionName).get().then(
            (value) => setLength(value.docs.length),
          );
    }

    stopwatch.stop();
    setState(() {
      elapsedTime = stopwatch.elapsed.toString();
    });
    print('Call took : ${stopwatch.elapsed}');
    setState(() {
      loading = false;
    });
  }

  void setLength(int length) {
    setState(() {
      itemLength = length.toString();
    });
    print('Documents loaded : $length');
  }
}
