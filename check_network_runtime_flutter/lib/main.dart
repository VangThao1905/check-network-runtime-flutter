import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Check Network Runtime Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Check Network Runtime Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectivityResult connectivityStatus = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectionSubscription;

  @override
  initState() {
    super.initState();
    connectionSubscription =
        connectivity.onConnectivityChanged.listen((onConnectionStatusChanged));
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (error) {
      print("Could not check connectivity status:$error");
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return onConnectionStatusChanged(result);
  }

  void onConnectionStatusChanged(ConnectivityResult result) {
    setState(() {
      connectivityStatus = result;
    });
  }

  @override
  dispose() {
    super.dispose();
    connectionSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Network status:${connectivityStatus.toString()}',
            ),
          ],
        ),
      ),
    );
  }
}
