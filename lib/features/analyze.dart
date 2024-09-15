import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyppart2/charts/bar_chart.dart';
import 'package:fyppart2/charts/pie_chart.dart';
// import 'package:fyppart2/charts/stacked_area_chart.dart';
import 'package:fyppart2/reading_data/data_model.dart';

class DataVisualizationScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DataVisualizationScreen({super.key});

  Future<List<Prediction>> _fetchPredictions() async {
    QuerySnapshot snapshot = await _firestore.collection('predictions').get();
    return snapshot.docs.map((doc) => Prediction.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("Data Visualization"),
      ),
      body: FutureBuilder(
        future: _fetchPredictions(),
        builder: (context, AsyncSnapshot<List<Prediction>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Prediction> predictions = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                BarChartWidget(predictions: predictions),
                // StackedAreaChartWidget(predictions: predictions),
                PieChartWidget(predictions: predictions),
              ],
            ),
          );
        },
      ),
    );
  }
}
