import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Connectivity Checker'),
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
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool checkfirst = false;
  @override
  void initState() {
    // TODO: implement initState
    getConnectivity();
    print('app started');
    if (checkfirst == false) {
      checkfirsttym();
    }
    super.initState();
  }

  void checkfirsttym() async {
    try {
      var url = Uri.https('www.google.com');
      var response = await http.get(url);
      checkfirst = true;
    } catch (e) {
      showDialogBox();
      setState(() {
        isAlertSet = true;
      });
    }
  }

  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();

        setState(() {
          print('internet disconnected');
          isAlertSet = true;
        });
      }
    });
  }

  showDialogBox() {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('No Connection'),
              content: const Text('Please check your internet Connecivity'),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context, 'Cancel');
                      setState(() {
                        print('internet connected');
                        isAlertSet = false;
                      });
                      isDeviceConnected =
                          await InternetConnectionChecker().hasConnection;
                      if (!isDeviceConnected) {
                        showDialogBox();

                        setState(() {
                          print('internet disconnected');
                          isAlertSet = true;
                        });
                      }
                    },
                    child: const Text('Ok'))
              ],
            ));
  }

  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const secondpage()));
        },
        child: const Text('Next Page'),
      )),
    );
  }
}

class secondpage extends StatefulWidget {
  const secondpage({Key? key}) : super(key: key);

  @override
  State<secondpage> createState() => _secondpageState();
}

class _secondpageState extends State<secondpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Second Page'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            )
          ],
        ),
      ),
    );
  }
}
