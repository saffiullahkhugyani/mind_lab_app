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
  int touchedIndexNumOfHours = -1;

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

    // Create a flattened list of all tags from all certificates
    final allTags = <String, int>{}; // A map to store tagName and total hours
    for (var certificate in widget.certificateMaster) {
      for (var tag in certificate.certificateMaster.tags) {
        allTags[tag.tagName] = (allTags[tag.tagName] ?? 0) + tag.hours;
      }
    }

    // Convert the map into a list of entries and sort by hours in descending order
    // final sortedTags = allTags.entries.toList()
    //   ..sort((a, b) => b.value.compareTo(a.value));

    // // Take the top 3 tags
    // final limitedTop3 = sortedTags.take(3).toList();

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
                margin: const EdgeInsets.only(
                    bottom: 20, left: 10, right: 10, top: 10),
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
                          SizedBox(height: 4),
                          Indicator(
                            color: AppPallete.contentColorGreen,
                            text: 'Life skill',
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
                      "Accumulated skills by type",
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
                                  touchedIndexNumOfHours = -1;
                                  return;
                                }
                                touchedIndexNumOfHours = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 5,
                          centerSpaceRadius: 30,
                          sections: generatePieChartSectionsForSkillTypeHours(
                              widget.certificateMaster), // Skill type data
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
                          SizedBox(height: 4),
                          Indicator(
                            color: AppPallete.contentColorGreen,
                            text: 'Life skill',
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
            // SizedBox(
            //   width: 250, // Adjust the width as per your requirement
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.grey[200],
            //       borderRadius: BorderRadius.circular(8),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black
            //               .withOpacity(0.2), // Shadow color with opacity
            //           spreadRadius: 2, // Spread radius
            //           blurRadius: 6, // Blur radius
            //           offset:
            //               const Offset(0, 3), // Offset in the X and Y direction
            //         ),
            //       ],
            //     ),
            //     padding: const EdgeInsets.all(4),
            //     margin: const EdgeInsets.only(
            //         bottom: 20, left: 10, right: 10, top: 10),
            //     child: Column(
            //       children: [
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         const Text(
            //           "Number of hours",
            //           style:
            //               TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //         ),
            //         AspectRatio(
            //           aspectRatio: 1.3,
            //           child: PieChart(
            //             PieChartData(
            //               pieTouchData: PieTouchData(
            //                 touchCallback:
            //                     (FlTouchEvent event, pieTouchResponse) {
            //                   setState(() {
            //                     if (!event.isInterestedForInteractions ||
            //                         pieTouchResponse == null ||
            //                         pieTouchResponse.touchedSection == null) {
            //                       touchedIndexNumOfHours = -1;
            //                       return;
            //                     }
            //                     touchedIndexNumOfHours = pieTouchResponse
            //                         .touchedSection!.touchedSectionIndex;
            //                   });
            //                 },
            //               ),
            //               borderData: FlBorderData(show: false),
            //               sectionsSpace: 5,
            //               centerSpaceRadius: 30,
            //               sections: generatePieChartSectionsForNumberOfHours(
            //                   widget.certificateMaster), // Skill type data
            //             ),
            //           ),
            //         ),
            //         buildHoursIndicators(limitedTop3)
            //       ],
            //     ),
            //   ),
            // ),
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
      'Programming': 0,
      'Life skill': 0,
    };

    for (var certificate in certificates) {
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

  List<PieChartSectionData> generatePieChartSectionsForNumberOfHours(
      List<CertificateV1V2MappingEntity> certificates) {
    // Create a flattened list of all tags from all certificates
    final allTags = <String, int>{}; // A map to store tagName and total hours
    for (var certificate in certificates) {
      for (var tag in certificate.certificateMaster.tags) {
        allTags[tag.tagName] = (allTags[tag.tagName] ?? 0) + tag.hours;
      }
    }

    // Convert the map into a list of entries and sort by hours in descending order
    final sortedTags = allTags.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take the top 3 tags
    final limitedTop3 = sortedTags.take(3).toList();

    return limitedTop3.asMap().entries.map((entry) {
      final index = entry.key;
      final hourEntry = entry.value;
      final isTouched = index == touchedIndexNumOfHours;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        value: hourEntry.value.toDouble(),
        title: '${hourEntry.value} (h)',
        color: _generateColor(index + 1),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<PieChartSectionData> generatePieChartSectionsForTotalNumberOfHours(
      List<CertificateV1V2MappingEntity> certificates) {
    // Create a flattened list of all tags from all certificates
    final allTags = <String, int>{}; // A map to store tagName and total hours
    for (var certificate in certificates) {
      for (var tag in certificate.certificateMaster.tags) {
        allTags[tag.tagName] = (allTags[tag.tagName] ?? 0) + tag.hours;
      }
    }

    // Convert the map into a list of entries and sort by hours in descending order
    final sortedTags = allTags.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take the top 3 tags
    final limitedTop3 = sortedTags.take(3).toList();

    return limitedTop3.asMap().entries.map((entry) {
      final index = entry.key;
      final hourEntry = entry.value;
      final isTouched = index == touchedIndexNumOfHours;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        value: hourEntry.value.toDouble(),
        title: '${hourEntry.value} (h)',
        color: _generateColor(index + 1),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<PieChartSectionData> generatePieChartSectionsForSkillTypeHours(
      List<CertificateV1V2MappingEntity> certificates) {
    // Create a map to store skillType and total hours
    final skillTypeHours = <String, int>{};

    for (var certificate in certificates) {
      final skillType = certificate.certificateMaster.skillType;
      final hours =
          int.tryParse(certificate.certificateMaster.numberOfHours) ?? 0;

      // Sum the total hours for each skill type
      skillTypeHours[skillType] = (skillTypeHours[skillType] ?? 0) + hours;
    }

    // Convert the map into a list of entries and sort by total hours in descending order
    final sortedSkillTypes = skillTypeHours.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Generate PieChartSectionData for the top 3 skill types
    return sortedSkillTypes.asMap().entries.map((entry) {
      final index = entry.key;
      final skillTypeEntry = entry.value;
      final isTouched = index == touchedIndexNumOfHours; // Highlight logic
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        value: skillTypeEntry.value.toDouble(),
        title: '${skillTypeEntry.value} h', // Skill type and total hours
        color: _getColorForSkillType(
            skillTypeEntry.key), // Pass index for color logic
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
    log(skillType);
    switch (skillType) {
      case 'Soft skill':
        return AppPallete.contentColorBlue;
      case 'Hard skill':
        return AppPallete.contentColorYellow;
      case 'Programming':
        return AppPallete.contentColorRed;
      case 'Life skill':
        return AppPallete.contentColorGreen;
      default:
        return Colors.grey;
    }
  }

  Color _generateColor(int seed) {
    switch (seed) {
      case 1:
        return AppPallete.contentColorBlue;
      case 2:
        return AppPallete.contentColorYellow;
      case 3:
        return AppPallete.contentColorRed;
      default:
        return Colors.grey;
    }
  }

  // Add this method to generate dynamic indicators for hours
  Widget buildHoursIndicators(List<MapEntry<String, int>> top3Hours) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: top3Hours.asMap().entries.map((entry) {
          final index = entry.key; // Get the index
          final tag = entry.value.key; // Get the actual MapEntry
          return Column(
            children: [
              Indicator(
                color: _generateColor(index + 1),
                text: '${tag}',
                isSquare: true,
              ),
              const SizedBox(height: 4),
            ],
          );
        }).toList(),
      ),
    );
  }
}
