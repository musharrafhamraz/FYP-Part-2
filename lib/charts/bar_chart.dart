import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyppart2/reading_data/data_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<Prediction> predictions;

  BarChartWidget({required this.predictions});

  @override
  Widget build(BuildContext context) {
    Map<String, int> predictionCounts = {};

    for (var prediction in predictions) {
      predictionCounts[prediction.prediction] =
          (predictionCounts[prediction.prediction] ?? 0) + 1;
    }

    List<BarChartGroupData> barGroups = predictionCounts.entries
        .map((entry) => BarChartGroupData(
              x: predictionCounts.keys.toList().indexOf(entry.key),
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color: Colors.blue,
                  width: 22,
                ),
              ],
            ))
        .toList();

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  String diseaseName =
                      predictionCounts.keys.elementAt(value.toInt());
                  return Text(
                    diseaseName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey, width: 1),
          ),
        ),
      ),
    );
  }
}
