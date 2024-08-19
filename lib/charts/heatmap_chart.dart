import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyppart2/reading_data/data_model.dart';

class TimeSeriesLineChart extends StatelessWidget {
  final List<Prediction> predictions;

  TimeSeriesLineChart({required this.predictions});

  @override
  Widget build(BuildContext context) {
    Map<DateTime, int> timeSeriesData = {};

    for (var prediction in predictions) {
      DateTime date = DateTime(prediction.timestamp.year,
          prediction.timestamp.month, prediction.timestamp.day);
      timeSeriesData[date] = (timeSeriesData[date] ?? 0) + 1;
    }

    List<FlSpot> spots = timeSeriesData.entries
        .map((entry) => FlSpot(entry.key.millisecondsSinceEpoch.toDouble(),
            entry.value.toDouble()))
        .toList();

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData:
                  BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            ),
          ],
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
