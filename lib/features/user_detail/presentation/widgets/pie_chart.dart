import 'dart:developer';

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
  int touchedIndexSkillLevel = -1;
  int touchedIndexSkillType = -1;

  @override
  Widget build(BuildContext context) {
    final skillLevelCounts = groupBySkillLevel(widget.certificateMaster);
    final skillLevels = skillLevelCounts.keys.toList();
    final skillLevelChartSections =
        generatePieChartSections(skillLevelCounts, skillLevels, true);

    final skillTypeCounts = groupBySkillType(widget.certificateMaster);
    final skillTypes = skillTypeCounts.keys.toList();
    final skillTypeChartSections =
        generatePieChartSections(skillTypeCounts, skillTypes, false);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Make charts scrollable horizontally
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 250, // Adjust the width as per your requirement
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Shadow color with opacity
                      spreadRadius: 2, // Spread radius
                      blurRadius: 6, // Blur radius
                      offset:
                          const Offset(0, 3), // Offset in the X and Y direction
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(bottom: 20, left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Skill Level",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndexSkillLevel = -1;
                                  return;
                                }
                                touchedIndexSkillLevel = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 5,
                          centerSpaceRadius: 30,
                          sections: skillLevelChartSections,
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
                          SizedBox(height: 4),
                          Indicator(
                            color: AppPallete.contentColorYellow,
                            text: 'Intermediate',
                            isSquare: true,
                          ),
                          SizedBox(height: 4),
                          Indicator(
                            color: AppPallete.contentColorRed,
                            text: 'Advanced',
                            isSquare: true,
                          ),
                          SizedBox(height: 4),
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
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 250, // Adjust the width as per your requirement
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Shadow color with opacity
                      spreadRadius: 2, // Spread radius
                      blurRadius: 6, // Blur radius
                      offset:
                          const Offset(0, 3), // Offset in the X and Y direction
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(
                    bottom: 20, left: 10, right: 10, top: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Skill Type",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndexSkillType = -1;
                                  return;
                                }
                                touchedIndexSkillType = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 5,
                          centerSpaceRadius: 30,
                          sections: skillTypeChartSections, // Skill type data
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
                            text: 'Soft Skill',
                            isSquare: true,
                          ),
                          SizedBox(height: 4),
                          Indicator(
                            color: AppPallete.contentColorYellow,
                            text: 'Hard Skill',
                            isSquare: true,
                          ),
                          SizedBox(height: 4),
                          Indicator(
                            color: AppPallete.contentColorRed,
                            text: 'Programming',
                            isSquare: true,
                          ),
                          // Add other skill type indicators here
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    skillLevelCounts.removeWhere((key, value) => value == 0);
    return skillLevelCounts;
  }

  Map<String, int> groupBySkillType(
      List<CertificateV1V2MappingEntity> certificates) {
    Map<String, int> skillTypeCounts = {
      'Soft skill': 0,
      'Hard skill': 0,
      'Programming': 0
    };

    for (var certificate in certificates) {
      log(certificates.length.toString());
      log(certificate.certificateMaster.skillType);
      String skillType = certificate.certificateMaster.skillType;
      if (skillTypeCounts.containsKey(skillType)) {
        skillTypeCounts[skillType] = skillTypeCounts[skillType]! + 1;
      }
    }
    skillTypeCounts.removeWhere((key, value) => value == 0);
    return skillTypeCounts;
  }

  List<PieChartSectionData> generatePieChartSections(
      Map<String, int> counts, List<String> keys, bool isSkillLevel) {
    return keys.asMap().entries.map((entry) {
      final index = entry.key;
      final key = entry.value;
      final isTouched = isSkillLevel
          ? index == touchedIndexSkillLevel
          : index == touchedIndexSkillType;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isSkillLevel
          ? _getColorForSkillLevel(key)
          : _getColorForSkillType(key);

      return PieChartSectionData(
        value: counts[key]!.toDouble(),
        title: '${counts[key]}',
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

  Color _getColorForSkillType(String skillType) {
    switch (skillType) {
      case 'Soft skill':
        return AppPallete.contentColorBlue;
      case 'Hard skill':
        return AppPallete.contentColorYellow;
      case 'Programming':
        return AppPallete.contentColorRed;
      default:
        return Colors.grey;
    }
  }
}
