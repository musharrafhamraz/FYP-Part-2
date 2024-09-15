import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyppart2/features/analyze.dart';
import 'package:fyppart2/features/month_base_disease_analysis.dart';
import 'package:timeago/timeago.dart' as timeago;

class AllDataScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AllDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("All Data"),
        actions: [
          PopupMenuButton(
            offset: Offset(0.0, appBarHeight),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            itemBuilder: (context) => [
              _buildPopupMenuItem(
                title: 'More Analysis',
                iconData: Icons.analytics,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PredictionAnalysisScreen()));
                },
              ),
            ],
          ),
        ],
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
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var doc = documents[index];
                var latitude = doc['latitude'];
                var longitude = doc['longitude'];
                var prediction = doc['prediction'];
                var timestamp = doc['timestamp'].toDate();

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prediction,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  8.0), // Space between prediction and time ago
                          Text(
                            'Diagnosed: ${timeago.format(timestamp)}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  8.0), // Space between time ago and coordinates
                          Text(
                            longitude.toString(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            latitude.toString(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
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

  PopupMenuItem _buildPopupMenuItem(
      {required String title,
      required IconData iconData,
      required void Function() onTap}) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(iconData, color: Colors.black),
          const SizedBox(width: 16), // Adds space between icon and text
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
