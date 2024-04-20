import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:workmanager/workmanager.dart';

void main() {
  runApp(const MyApp());

  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true, // Posts notification whenever the task is running
  // );

  // Workmanager().registerPeriodicTask(
  //   "automatic-json-update",
  //   "periodicUpdate",
  //   existingWorkPolicy: ExistingWorkPolicy.replace,
  //   frequency: const Duration(minutes: 15),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnSite',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String location = "Waiting for location...";

  void _updateLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        location = "Location services are disabled.";
      });
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = "Location permissions are denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return;
    }

    // If permissions are granted, get the current position
    try {
      setState(() {
        location = "Getting location...";
      });
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        location = "${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        location = "Failed to get location: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called. The Flutter framework
    // has been optimized to make rerunning build methods fast.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your coords:',
            ),
            Text(
              location,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateLocation,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Function to get the current location.
Future<Position> getLocationInBackground() async {
  try {
    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue.
      throw Exception('Location services are disabled.');
    }

    // Check location permission.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue.
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, don't continue.
      throw Exception(
          'Location permissions are permanently denied; we cannot request permissions.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    return position;
  } catch (e) {
    // Handle errors or exceptions
    print('Error occurred: $e');
    rethrow; // Re-throw the exception to be handled by the caller.
  }
}

void sendLocationToServer(String location) {
  print("Sending location to server: $location");
  // TODO: Implement sending location to server
}

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     String location = "Unknown"; // TODO: remove initial value
//     var position = await getLocationInBackground();
//     location = "${position.latitude}, ${position.longitude}";
//     sendLocationToServer(location);
//     return Future.value(true);
//   });
// }
