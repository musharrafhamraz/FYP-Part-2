import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'coordinates.dart';

class PredictionAnalysisHelper {
  final coordinates = CoordinatesClass();

  // Sort and return top N predictions
  List<MapEntry<String, int>> findTopFrequentPredictions(
      Map<String, int> predictionCount, int topN) {
    var sorted = predictionCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(topN).toList();
  }

  // Count predictions based on provided documents
  Future<Map<String, int>> countPredictions(List<DocumentSnapshot> documents,
      String selectedMonth, int selectedYear) async {
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
        // Get the place name from coordinates
        String placeName = 'Unknown'; // Default value

        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latitude, longitude);

          if (placemarks.isNotEmpty) {
            placeName = placemarks.first.locality ??
                placemarks.first.subLocality ??
                placemarks.first.administrativeArea ??
                placemarks.first.country ??
                'Unknown';
          }
        } catch (e) {
          print("Error fetching place name: $e");
        }

        // If no valid place name is found, check the predefined locations list
        if (placeName == 'Unknown') {
          placeName = coordinates.getPlaceNameFromPredefinedLocations(
              latitude, longitude);
        }

        // Concatenate prediction and place name
        String key = '$prediction at $placeName';

        // Update the location-based prediction count
        locationBasedCount[key] = (locationBasedCount[key] ?? 0) + 1;
      }
    }

    // Merge counts from locationBasedCount into predictionCount
    locationBasedCount.forEach((key, count) {
      predictionCount[key] = (predictionCount[key] ?? 0) + count;
    });

    return predictionCount;
  }

  List<String> getAllMonths() {
    return List<String>.generate(12, (index) {
      return DateFormat.MMMM().format(DateTime(0, index + 1));
    });
  }

  // Fetch place names based on the selected month
  Future<List<String>> getPlaceNamesForMonth(
      String selectedMonth, int selectedYear) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<String> placeNames = [];
    QuerySnapshot snapshot = await _firestore.collection('predictions').get();

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      var timestamp = data['timestamp'].toDate();
      int month = timestamp.month;
      int year = timestamp.year;
      double latitude = data['latitude'];
      double longitude = data['longitude'];

      if (DateFormat.MMMM().format(DateTime(0, month)) == selectedMonth &&
          year == selectedYear) {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        String placeName = placemarks.isNotEmpty
            ? placemarks.first.locality ??
                placemarks.first.subLocality ??
                placemarks.first.administrativeArea ??
                placemarks.first.country ??
                'Unknown'
            : 'Unknown';
        if (!placeNames.contains(placeName)) {
          placeNames.add(placeName);
        }
      }
    }
    return placeNames;
  }

  // Count predictions by place for the selected month and year
  Future<Map<String, int>> countPredictionsByPlace(
    List<DocumentSnapshot> documents,
    String selectedMonth,
    int selectedYear,
    String placeName,
  ) async {
    Map<String, int> predictionCount = {};

    for (var doc in documents) {
      var data = doc.data() as Map<String, dynamic>;
      var timestamp = data['timestamp'].toDate();
      int month = timestamp.month;
      int year = timestamp.year;
      String prediction = data['prediction'];
      double latitude = data['latitude'];
      double longitude = data['longitude'];

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      String docPlaceName = placemarks.isNotEmpty
          ? placemarks.first.locality ??
              placemarks.first.subLocality ??
              placemarks.first.administrativeArea ??
              placemarks.first.country ??
              'Unknown'
          : 'Unknown';

      if (DateFormat.MMMM().format(DateTime(0, month)) == selectedMonth &&
          year == selectedYear &&
          docPlaceName == placeName) {
        predictionCount[prediction] = (predictionCount[prediction] ?? 0) + 1;
      }
    }

    return predictionCount;
  }
}
