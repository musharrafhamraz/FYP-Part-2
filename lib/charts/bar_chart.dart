import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyppart2/reading_data/data_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<Prediction> predictions;

  const BarChartWidget({required this.predictions});

  @override
  Widget build(BuildContext context) {
    // Map to hold the count of each disease prediction
    Map<String, int> predictionCounts = {};

    // Count the occurrences of each prediction
    for (var prediction in predictions) {
      predictionCounts[prediction.prediction] =
          (predictionCounts[prediction.prediction] ?? 0) + 1;
    }

    // Limit the number of diseases to 9
    final limitedPredictionCounts = predictionCounts.entries.take(9).toList();

    // List of colors for each bar (and corresponding disease name)
    List<Color> barColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    // Find the maximum count to set the maxY value with extra space
    double maxCount = limitedPredictionCounts
        .map((entry) => entry.value)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    double maxY = maxCount + 3; // Adding extra space above the highest bar

    // Create bar chart groups with colors matching the diseases
    List<BarChartGroupData> barGroups = limitedPredictionCounts.map((entry) {
      int index = limitedPredictionCounts.indexOf(entry);
      return BarChartGroupData(
        barsSpace: 10,
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: barColors[index % barColors.length],
            width: 22,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    return Column(
      children: [
        // Display disease names with matching colors in a GridView
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: 100, // Adjust the height according to your needs
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Three columns in the grid
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 4, // Adjust aspect ratio to fit the text
              ),
              itemCount: limitedPredictionCounts.length, // Limit to 9 diseases
              itemBuilder: (context, index) {
                String disease = limitedPredictionCounts[index].key;
                return Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      color: barColors[index % barColors.length],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        disease,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: maxY, // Set the maxY to give extra space
              barGroups: barGroups,
              titlesData: const FlTitlesData(
                // Hide all side titles
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    "Diseases",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              barTouchData: BarTouchData(
                enabled: false, // Disable touch for static labels
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
        // Add the numbers above the bars
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: limitedPredictionCounts.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  '${entry.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
