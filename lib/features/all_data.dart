import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';
import 'package:fyppart2/features/analyze.dart';
import 'package:fyppart2/features/month_base_disease_analysis.dart';
import 'package:timeago/timeago.dart' as timeago;

class AllDataScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of predefined colors
  final List<Color> cardColors = [
    const Color.fromRGBO(88, 10, 4, 1),
    const Color.fromRGBO(6, 58, 101, 1),
    const Color.fromARGB(255, 7, 87, 10),
    const Color.fromRGBO(85, 53, 6, 1),
    const Color.fromARGB(255, 85, 9, 99),
    const Color.fromARGB(255, 5, 98, 89),
    const Color.fromARGB(255, 78, 70, 4),
    const Color.fromARGB(255, 102, 10, 40),
  ];

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
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            itemBuilder: (context) => [
              _buildPopupMenuItem(
                title: 'More Analysis',
                iconData: Icons.analytics,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PredictionAnalysisScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: StreamBuilder(
          stream: _firestore.collection('predictions').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: SpinKitWaveSpinner(
                color: Colors.teal,
                size: 70,
                waveColor: Colors.teal.shade600,
                trackColor: Colors.teal.shade200,
              ));
            }

            List<DocumentSnapshot> documents = snapshot.data!.docs;

            // Display the data using StaggeredGrid
            return MasonryGridView.count(
              crossAxisCount: 2, // 2 cards per row
              // mainAxisSpacing: 1,
              // crossAxisSpacing: 1,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var doc = documents[index];
                var latitude = doc['latitude'];
                var longitude = doc['longitude'];
                var prediction = doc['prediction'];
                var timestamp = doc['timestamp'].toDate();

                // Generate a random color for the card
                Color cardColor =
                    cardColors[Random().nextInt(cardColors.length)];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Prediction title
                        Text(
                          prediction,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          // maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6.0),
                        // Time information
                        Text(
                          'Diagnosed: ${timeago.format(timestamp)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        // Display latitude and longitude
                        Text(
                          'Lat: ${latitude.toString()}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Lon: ${longitude.toString()}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DataVisualizationScreen()),
          );
        },
        icon: const Icon(Icons.analytics, color: Colors.white),
        label: const Text("Visualize Data"),
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
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
