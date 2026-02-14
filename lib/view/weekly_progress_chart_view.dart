import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/week_progress_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyProgressChartView extends StatefulWidget {
  final List<WeekProgressModel> weekProgressList;
  const WeeklyProgressChartView({Key? key, required this.weekProgressList}) : super(key: key);

  @override
  State<WeeklyProgressChartView> createState() => _WeeklyProgressChartViewState();
}

class _WeeklyProgressChartViewState extends State<WeeklyProgressChartView> {
  // Track which lines are shown
  Map<String, bool> _selected = {
    'pelvis': false,
    'waist': false, // default selected
    'rightArm': false,
    'weight': true,
  };

  // Color mapping for lines
  final Map<String, Color> _lineColors = {
    'pelvis': Colors.lightGreen,
    'waist': Colors.blue.shade900,
    'rightArm': Colors.orangeAccent,
    'weight': Colors.red,
  };

  // Label mapping
  final Map<String, String> _labels = {
    'pelvis': 'حوض',
    'waist': 'الوسط',
    'rightArm': 'وسط الذراع',
    'weight': 'الوزن',
  };

  List<String> get _fields => _selected.keys.toList();

  /// Filter out weeks that have excuses
  List<WeekProgressModel> get _filteredData {
    return widget.weekProgressList
        .where((wp) => wp.excuse.trim().isEmpty)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<DateTime> get _filteredMonths =>
      _filteredData.map((e) => e.date).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "التقدم اللأسبوعى"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
                    LineChartData(
                      minY: _getMinY(_filteredData),
                      maxY: _getMaxY(_filteredData),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int idx = value.toInt();
                              if (idx < 0 || idx >= _filteredMonths.length) return const SizedBox.shrink();
                              final date = _filteredMonths[idx];
                              return Text(
                                _monthShort(date.month),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                            interval: 1,
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: true),

                      /// Touch tooltips
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.black.withOpacity(0.7),
                          tooltipRoundedRadius: 8,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                '${spot.y.toStringAsFixed(2)}',
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                          if (event is FlTapUpEvent && response?.lineBarSpots != null) {
                            for (var spot in response!.lineBarSpots!) {
                              print('Clicked: x=${spot.x}, y=${spot.y}');
                            }
                          }
                        },
                        handleBuiltInTouches: true,
                      ),

                      /// Data for selected lines
                      lineBarsData: _fields.where((f) => _selected[f]!).map((field) {
                        return LineChartBarData(
                          spots: List.generate(_filteredData.length, (i) {
                            final v = _getValue(_filteredData[i], field);
                            return FlSpot(i.toDouble(), v);
                          }),
                          isCurved: true,
                          color: _lineColors[field],
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: _fields.map((field) {
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _lineColors[field],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(_labels[field]!),
                    ],
                  ),
                  selected: _selected[field]!,
                  onSelected: (val) {
                    setState(() {
                      _selected[field] = val;
                    });
                  },
                  selectedColor: _lineColors[field]!.withOpacity(0.15),
                  checkmarkColor: _lineColors[field],
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  double _getValue(WeekProgressModel model, String field) {
    switch (field) {
      case 'pelvis':
        return model.pelvis;
      case 'waist':
        return model.waist;
      case 'rightArm':
        return model.rightArm;
      case 'weight':
        return model.weight;
      default:
        return 0;
    }
  }

  double _getMinY(List<WeekProgressModel> list) {
    double min = double.infinity;
    for (var f in _fields.where((f) => _selected[f]!)) {
      for (var m in list) {
        final v = _getValue(m, f);
        if (v < min) min = v;
      }
    }
    return min == double.infinity ? 0 : min - 10;
  }

  double _getMaxY(List<WeekProgressModel> list) {
    double max = double.negativeInfinity;
    for (var f in _fields.where((f) => _selected[f]!)) {
      for (var m in list) {
        final v = _getValue(m, f);
        if (v > max) max = v;
      }
    }
    return max == double.negativeInfinity ? 100 : max + 10;
  }

  String _monthShort(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
