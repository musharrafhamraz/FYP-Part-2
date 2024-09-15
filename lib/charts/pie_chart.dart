import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyppart2/reading_data/data_model.dart';

class PieChartWidget extends StatefulWidget {
  final List<Prediction> predictions;

  PieChartWidget({required this.predictions});

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  String? selectedPrediction;

  @override
  Widget build(BuildContext context) {
    Map<String, int> predictionCounts = {};

    for (var prediction in widget.predictions) {
      predictionCounts[prediction.prediction] =
          (predictionCounts[prediction.prediction] ?? 0) + 1;
    }

    List<PieChartSectionData> sections = predictionCounts.entries.map((entry) {
      int index = predictionCounts.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.value}',
        color: Colors.primaries[index % Colors.primaries.length],
        radius: 50,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 350,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 70,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback:
                    (FlTouchEvent event, PieTouchResponse? response) {
                  if (event is FlTapUpEvent) {
                    final sectionIndex =
                        response?.touchedSection?.touchedSectionIndex;
                    if (sectionIndex != null) {
                      setState(() {
                        selectedPrediction =
                            predictionCounts.keys.toList()[sectionIndex];
                      });
                    }
                  }
                },
                mouseCursorResolver: (event, response) =>
                    SystemMouseCursors.click,
              ),
            ),
          ),
        ),
        if (selectedPrediction != null)
          Positioned(
            top: 5,
            child: Card(
              color: Color.fromRGBO(75, 38, 38, 1),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Text(
                  '$selectedPrediction',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
