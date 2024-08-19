import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyppart2/features/all_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AllDataScreen(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter_android/google_maps_flutter_android.dart'; // Adjust import based on actual package
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'; // Adjust import based on actual package
// import 'package:fyppart2/reading_data/data_model.dart';

// void main() {
//   // Ensure Flutter bindings are initialized
//   WidgetsFlutterBinding.ensureInitialized();

//   // Set the map renderer to the latest version if possible
//   final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
//   if (mapsImplementation is GoogleMapsFlutterAndroid) {
//     mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
//   }

//   // Run the app
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Heatmap Example',
//       home: Scaffold(
//         appBar: AppBar(title: Text('Heatmap Example')),
//         body: HeatmapWidget(
//           predictions: [
//             // Example predictions data
//             Prediction(latitude: 37.7749, longitude: -122.4194, prediction: 'Disease A', timestamp: DateTime.now()),
//             Prediction(latitude: 34.0522, longitude: -118.2437, prediction: 'Disease B', timestamp: DateTime.now()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HeatmapWidget extends StatelessWidget {
//   final List<Prediction> predictions;

//   HeatmapWidget({required this.predictions});

//   @override
//   Widget build(BuildContext context) {
//     Set<Marker> markers = predictions.map((prediction) {
//       return Marker(
//         markerId: MarkerId(prediction.timestamp.toString()),
//         position: LatLng(prediction.latitude, prediction.longitude),
//         infoWindow: InfoWindow(
//           title: prediction.prediction,
//           snippet: prediction.timestamp.toString(),
//         ),
//       );
//     }).toSet();

//     return SizedBox(
//       height: 300,
//       child: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(predictions[0].latitude, predictions[0].longitude),
//           zoom: 5,
//         ),
//         markers: markers,
//         onMapCreated: (GoogleMapController controller) {
//           // Additional map initialization code can be placed here
//         },
//       ),
//     );
//   }
// }
