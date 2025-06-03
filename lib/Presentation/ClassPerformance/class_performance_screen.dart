import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StudentPerformancePieChart extends StatefulWidget {
  const StudentPerformancePieChart({super.key});

  @override
  State<StudentPerformancePieChart> createState() =>
      _StudentPerformancePieChartState();
}

class _StudentPerformancePieChartState
    extends State<StudentPerformancePieChart> {
  final List<String> classList = [
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12'
  ];
  String selectedClass = 'Class 9';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, int> categoryCount = {
    'Giỏi': 0,
    'Khá': 0,
    'Trung bình': 0,
    'Yếu': 0,
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      categoryCount = {'Giỏi': 0, 'Khá': 0, 'Trung bình': 0, 'Yếu': 0};
    });

    try {
      final quizSnapshot = await _firestore
          .collection('Quizzes')
          .doc(selectedClass)
          .collection('quiz')
          .get();

      // Map studentId -> list of percentages (double)
      Map<String, List<double>> studentScores = {};

      for (var doc in quizSnapshot.docs) {
        final data = doc.data();
        final int totalMarks = (data['totalMarks'] ?? 100);

        if (totalMarks == 0) continue; // tránh chia cho 0

        final students = Map<String, dynamic>.from(data['students'] ?? {});

        students.forEach((studentId, score) {
          int actualScore = 0;
          if (score is int) {
            actualScore = score;
          } else if (score is String) {
            actualScore = int.tryParse(score) ?? 0;
          }

          double percentage = (actualScore / totalMarks) * 100;

          if (!studentScores.containsKey(studentId)) {
            studentScores[studentId] = [];
          }
          studentScores[studentId]!.add(percentage);
        });
      }

      // Tính trung bình và phân loại
      studentScores.forEach((studentId, percentages) {
        if (percentages.isEmpty) return;

        double avg = percentages.reduce((a, b) => a + b) / percentages.length;

        if (avg.isNaN || avg.isInfinite) return;

        if (avg >= 85) {
          categoryCount['Giỏi'] = categoryCount['Giỏi']! + 1;
        } else if (avg >= 70) {
          categoryCount['Khá'] = categoryCount['Khá']! + 1;
        } else if (avg >= 50) {
          categoryCount['Trung bình'] = categoryCount['Trung bình']! + 1;
        } else {
          categoryCount['Yếu'] = categoryCount['Yếu']! + 1;
        }
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<PieChartSectionData> getPieChartSections() {
    final total = categoryCount.values.fold(0, (sum, val) => sum + val);
    if (total == 0) return [];

    final colors = [Colors.green, Colors.blue, Colors.orange, Colors.red];
    final keys = categoryCount.keys.toList();

    return List.generate(4, (i) {
      final label = keys[i];
      final count = categoryCount[label]!;
      final percentage = (count / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: colors[i],
        value: count.toDouble(),
        title: '$label\n$percentage%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biểu đồ học lực'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(38),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedClass,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.blueAccent),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    items: classList
                        .map<DropdownMenuItem<String>>((String classNo) {
                      return DropdownMenuItem<String>(
                        value: classNo,
                        child: Text("Lớp $classNo"),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null && value != selectedClass) {
                        setState(() {
                          selectedClass = value;
                        });
                        fetchData();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : categoryCount.values.every((v) => v == 0)
                    ? const Text(
                        "Không có dữ liệu.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: getPieChartSections(),
                            centerSpaceRadius: 40,
                            sectionsSpace: 4,
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
