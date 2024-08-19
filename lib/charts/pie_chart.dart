import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyppart2/reading_data/data_model.dart';

class PieChartWidget extends StatelessWidget {
  final List<Prediction> predictions;

  PieChartWidget({required this.predictions});

  @override
  Widget build(BuildContext context) {
    Map<String, int> predictionCounts = {};

    for (var prediction in predictions) {
      predictionCounts[prediction.prediction] =
          (predictionCounts[prediction.prediction] ?? 0) + 1;
    }

    List<PieChartSectionData> sections = predictionCounts.entries
        .map((entry) => PieChartSectionData(
              value: entry.value.toDouble(),
              title: '${entry.value}',
              color: Colors.primaries[
                  predictionCounts.keys.toList().indexOf(entry.key) %
                      Colors.primaries.length],
              radius: 50,
            ))
        .toList();

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
