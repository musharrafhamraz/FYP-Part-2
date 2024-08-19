import 'package:cloud_firestore/cloud_firestore.dart';

class Prediction {
  final double latitude;
  final double longitude;
  final String prediction;
  final DateTime timestamp;

  Prediction({
    required this.latitude,
    required this.longitude,
    required this.prediction,
    required this.timestamp,
  });

  factory Prediction.fromDocument(DocumentSnapshot doc) {
    return Prediction(
      latitude: doc['latitude'],
      longitude: doc['longitude'],
      prediction: doc['prediction'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }
}
