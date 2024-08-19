import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyppart2/reading_data/data_model.dart';

class StackedAreaChartWidget extends StatelessWidget {
  final List<Prediction> predictions;

  StackedAreaChartWidget({required this.predictions});

  @override
  Widget build(BuildContext context) {
    Map<String, List<FlSpot>> diseaseSpots = {};

    for (var prediction in predictions) {
      DateTime date = DateTime(prediction.timestamp.year,
          prediction.timestamp.month, prediction.timestamp.day);
      double x = date.millisecondsSinceEpoch.toDouble();

      if (!diseaseSpots.containsKey(prediction.prediction)) {
        diseaseSpots[prediction.prediction] = [];
      }
      diseaseSpots[prediction.prediction]?.add(
          FlSpot(x, (diseaseSpots[prediction.prediction]?.length ?? 0) + 1));
    }

    List<LineChartBarData> lineBarsData = diseaseSpots.entries.map((entry) {
      return LineChartBarData(
        spots: entry.value,
        isCurved: true,
        color: Colors.blueAccent.withOpacity(0.5),
        belowBarData:
            BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.3)),
      );
    }).toList();

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: lineBarsData,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  DateTime date =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Text("${date.day}/${date.month}");
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}
