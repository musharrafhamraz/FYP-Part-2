import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class PredictionAnalysisScreen extends StatefulWidget {
  @override
  _PredictionAnalysisScreenState createState() =>
      _PredictionAnalysisScreenState();
}

class _PredictionAnalysisScreenState extends State<PredictionAnalysisScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedMonth = DateFormat.MMMM().format(DateTime.now());
  int selectedYear = DateTime.now().year;

  // Get all unique months from the data
  List<String> getAllMonths() {
    return List<String>.generate(12, (index) {
      return DateFormat.MMMM().format(DateTime(0, index + 1));
    });
  }

  // Count predictions in the selected month
  Future<Map<String, int>> countPredictions(
      List<DocumentSnapshot> documents) async {
    Map<String, int> predictionCount = {};
    Map<String, int> locationBasedCount = {};

    for (var doc in documents) {
      var data = doc.data() as Map<String, dynamic>;
      var timestamp = data['timestamp'].toDate();
      int month = timestamp.month;
      int year = timestamp.year;
      String prediction = data['prediction'];
      double latitude = data['latitude'];
      double longitude = data['longitude'];

      // Check if the document matches the selected month and year
      if (DateFormat.MMMM().format(DateTime(0, month)) == selectedMonth &&
          year == selectedYear) {
        // Update prediction count
        predictionCount[prediction] = (predictionCount[prediction] ?? 0) + 1;

        // Get the place name from coordinates
        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latitude, longitude);
          String placeName = placemarks.isNotEmpty
              ? placemarks.first.locality ?? 'Unknown'
              : 'Unknown';

          String key = '$prediction at $placeName';
          locationBasedCount[key] = (locationBasedCount[key] ?? 0) + 1;
        } catch (e) {
          // Handle potential geocoding errors
          print("Error fetching place name: $e");
        }
      }
    }

    // Merge counts from locationBasedCount into predictionCount
    locationBasedCount.forEach((key, count) {
      predictionCount[key] = (predictionCount[key] ?? 0) + count;
    });

    return predictionCount;
  }

  // Find the top N frequent predictions
  List<MapEntry<String, int>> findTopFrequentPredictions(
      Map<String, int> predictionCount, int topN) {
    var sorted = predictionCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(topN).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction Analysis"),
      ),
      body: Column(
        children: [
          // Dropdown to select month
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedMonth,
              items:
                  getAllMonths().map<DropdownMenuItem<String>>((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMonth = newValue!;
                });
              },
            ),
          ),
          // Stream to fetch and analyze data
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('predictions').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;
                return FutureBuilder<Map<String, int>>(
                  future: countPredictions(documents),
                  builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                              "No predictions available for the selected month."));
                    }

                    Map<String, int> predictionCount = snapshot.data!;
                    var topPredictions =
                        findTopFrequentPredictions(predictionCount, 3);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Predictions in $selectedMonth: ${predictionCount.values.reduce((a, b) => a + b)}",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        ...topPredictions
                            .map((entry) => Text(
                                  "${entry.key}: ${entry.value}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ))
                            .toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
