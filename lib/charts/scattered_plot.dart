// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:fyppart2/reading_data/data_model.dart';

// class ScatterPlotWidget extends StatelessWidget {
//   final List<Prediction> predictions;

//   ScatterPlotWidget({required this.predictions});

//   @override
//   Widget build(BuildContext context) {
//     List<ScatterSpot> spots = predictions.map((prediction) {
//       return ScatterSpot(
//         prediction.longitude,
//         prediction.latitude,
//       );
//     }).toList();

//     return SizedBox(
//       height: 300,
//       child: ScatterChart(
//         ScatterChartData(
//           scatterSpots: spots,
//           borderData: FlBorderData(show: true),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   return Text(value.toInt().toString());
//                 },
//               ),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   return Text(value.toInt().toString());
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:fyppart2/reading_data/data_model.dart';

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
//       ),
//     );
//   }
// }
