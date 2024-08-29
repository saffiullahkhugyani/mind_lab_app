import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../domain/entities/certificate_v2_entity.dart';
import 'indicator.dart';

class Piechart extends StatefulWidget {
  final List<CertificateV1V2MappingEntity> certificateMaster;

  const Piechart({super.key, required this.certificateMaster});

  @override
  State<Piechart> createState() => _PiechartState();
}

class _PiechartState extends State<Piechart> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final skillLevelCounts = groupBySkillLevel(widget.certificateMaster);
    final skillLevels = skillLevelCounts.keys.toList();
    final pieChartSections =
        generatePieChartSections(skillLevelCounts, skillLevels);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 5,
                  centerSpaceRadius: 30,
                  sections: pieChartSections,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Indicator(
                  color: AppPallete.contentColorBlue,
                  text: 'Basic',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: AppPallete.contentColorYellow,
                  text: 'Intermediate',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: AppPallete.contentColorRed,
                  text: 'Advanced',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: AppPallete.contentColorGreen,
                  text: 'Professional',
                  isSquare: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> groupBySkillLevel(
      List<CertificateV1V2MappingEntity> certificates) {
    Map<String, int> skillLevelCounts = {
      'Basic': 0,
      'Intermediate': 0,
      'Advanced': 0,
      'Professional': 0,
    };

    for (var certificate in certificates) {
      String skillLevel = certificate.certificateMaster.skillLevel;

      if (skillLevelCounts.containsKey(skillLevel)) {
        skillLevelCounts[skillLevel] = skillLevelCounts[skillLevel]! + 1;
      }
    }
    // Remove entries with zero count
    skillLevelCounts.removeWhere((key, value) => value == 0);

    return skillLevelCounts;
  }

  List<PieChartSectionData> generatePieChartSections(
      Map<String, int> skillLevelCounts, List<String> skillLevels) {
    return skillLevels.asMap().entries.map((entry) {
      final index = entry.key;
      final skillLevel = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = _getColorForSkillLevel(skillLevel);

      return PieChartSectionData(
        value: skillLevelCounts[skillLevel]!.toDouble(),
        title: '${skillLevelCounts[skillLevel]}',
        color: color,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  String getTouchedSkillLevel() {
    final skillLevels = ['Basic', 'Intermediate', 'Advanced', 'Professional'];
    if (touchedIndex >= 0 && touchedIndex < skillLevels.length) {
      print(touchedIndex);
      return skillLevels[touchedIndex];
    }
    return '';
  }

  Color _getColorForSkillLevel(String skillLevel) {
    switch (skillLevel) {
      case 'Basic':
        return AppPallete.contentColorBlue;
      case 'Intermediate':
        return AppPallete.contentColorYellow;
      case 'Advanced':
        return AppPallete.contentColorRed;
      case 'Professional':
        return AppPallete.contentColorGreen;
      default:
        return Colors.grey;
    }
  }
}
