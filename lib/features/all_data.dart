import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyppart2/features/analyze.dart';

class AllDataScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AllDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "All Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: StreamBuilder(
          stream: _firestore.collection('predictions').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<DocumentSnapshot> documents = snapshot.data!.docs;

            // Display the data in a list
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var doc = documents[index];
                var latitude = doc['latitude'];
                var longitude = doc['longitude'];
                var prediction = doc['prediction'];
                var timestamp = doc['timestamp'].toDate();

                return ListTile(
                  title: Text(prediction),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latitude: $latitude'),
                      Text('Longitude: $longitude'),
                      Text('Timestamp: $timestamp'),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DataVisualizationScreen()),
          );
        },
        child: const Icon(
          Icons.analytics,
          color: Colors.white,
        ),
      ),
    );
  }
}
