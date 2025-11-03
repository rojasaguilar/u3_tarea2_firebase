import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  String realTimeValue = "0";
  String getOnceValue = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _fApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Somethings bad with firebase");
          } else if (snapshot.hasData) {
            return content();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget content() {
    DatabaseReference _testRef = FirebaseDatabase.instance.ref().child('count');
    //LISTEN TO REALTIME DATABASE VALUE
    _testRef.onValue.listen((event) {
      setState(() {
        realTimeValue = event.snapshot.value.toString();
      });
    });
    // _testRef.update(Map<"count","190">);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Real time counter: $realTimeValue")),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final snapshot = await _testRef.get();
              if (snapshot.exists) {
                setState(() {
                  getOnceValue = snapshot.value.toString();
                });
              } else {
                print("no value ");
              }
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text("Get Once", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(child: Text("Get once counter: $getOnceValue")),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              await _testRef.set((int.parse(realTimeValue) + 1));
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text("Add one", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
