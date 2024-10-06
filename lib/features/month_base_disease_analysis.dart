import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyppart2/helper_functions/analysis_helper_class.dart';
import 'package:intl/intl.dart';

class PredictionAnalysisScreen extends StatefulWidget {
  const PredictionAnalysisScreen({super.key});

  @override
  PredictionAnalysisScreenState createState() =>
      PredictionAnalysisScreenState();
}

class PredictionAnalysisScreenState extends State<PredictionAnalysisScreen>
    with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedMonth = DateFormat.MMMM().format(DateTime.now());
  int selectedYear = DateTime.now().year;

  TabController? _tabController;
  List<String> placeNames = [];
  final PredictionAnalysisHelper _helper = PredictionAnalysisHelper();

  @override
  void initState() {
    super.initState();
    _fetchPlaceNames();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchPlaceNames() async {
    List<String> fetchedPlaceNames = await _helper.getPlaceNamesForMonth(
      selectedMonth,
      selectedYear,
    );

    // Set the placeNames first, then handle TabController creation/disposal
    setState(() {
      placeNames = fetchedPlaceNames;
    });
    print(placeNames);
    // After updating the state, handle TabController re-creation
    if (_tabController != null) {
      _tabController!.dispose();
    }

    // Create new TabController if placeNames are available
    if (placeNames.isNotEmpty) {
      _tabController = TabController(
        length: placeNames.length,
        vsync: this,
      );
    } else {
      _tabController = null;
    }

    setState(() {}); // Force rebuild after creating the new TabController
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("In-Depth Analysis"),
        bottom: placeNames.isNotEmpty && _tabController != null
            ? TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                controller: _tabController,
                isScrollable: true,
                tabs: placeNames.map((place) => Tab(text: place)).toList(),
              )
            : null,
      ),
      body: placeNames.isNotEmpty && _tabController != null
          ? TabBarView(
              controller: _tabController,
              children: placeNames.map((place) {
                return _buildPredictionStreamForPlace(place);
              }).toList(),
            )
          : Center(
              child: SpinKitWaveSpinner(
              color: Colors.teal,
              size: 70,
              waveColor: Colors.teal.shade600,
              trackColor: Colors.teal.shade200,
            )),
      floatingActionButton: _buildMonthDropdown(),
    );
  }

  // Dropdown for selecting month
  Widget _buildMonthDropdown() {
    return DropdownButton<String>(
      value: selectedMonth,
      items:
          _helper.getAllMonths().map<DropdownMenuItem<String>>((String month) {
        return DropdownMenuItem<String>(
          value: month,
          child: Text(month),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedMonth = newValue!;
          _fetchPlaceNames(); // Refresh place names and TabController
        });
      },
    );
  }

  // StreamBuilder for fetching and displaying predictions for a specific place
  Widget _buildPredictionStreamForPlace(String placeName) {
    return StreamBuilder<QuerySnapshot>(
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
        return FutureBuilder<Map<String, int>>(
          future: _helper.countPredictionsByPlace(
              documents, selectedMonth, selectedYear, placeName),
          builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: SpinKitWaveSpinner(
                color: Colors.teal,
                size: 70,
                waveColor: Colors.teal.shade600,
                trackColor: Colors.teal.shade200,
              ));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text("No predictions available for this place."));
            }

            Map<String, int> predictionCount = snapshot.data!;
            return _buildPredictionList(predictionCount);
          },
        );
      },
    );
  }

  // Display the diseases and their count for a place
  Widget _buildPredictionList(Map<String, int> predictionCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  textAlign: TextAlign.end,
                  "Total: ${predictionCount.values.reduce((a, b) => a + b)}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...predictionCount.entries.map((entry) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: Text("Count: ${entry.value}"),
                  ));
            }),
          ],
        ),
      ),
    );
  }
}
