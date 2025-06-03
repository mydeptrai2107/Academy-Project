import 'package:ahmed_academy/Logic/quiz_bloc.dart';
import 'package:ahmed_academy/Settings/Widget/fetching_students.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizReview extends StatelessWidget {
  const QuizReview({required this.classNo, super.key});

  final String classNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quiz Review",
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
            Text(
              classNo,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Mulish', fontSize: 14),
            )
          ],
        ),
        leading: InkWell(
          onTap: () {
            PushNavigation.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        titleSpacing: 0,
        elevation: 2,
        toolbarHeight: 80,
        shadowColor: Colors.black,
        backgroundColor: CustomTheme().selectedTextColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => QuizBloc()..add(FetchQuizEvent(classNo)),
        child: Builder(builder: (context) {
          return BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              if (state is QuizLoading) {
                return const FetchingStudents(
                  text: "Loading Quizzes",
                );
              } else if (state is QuizLoaded) {
                if (state.quizList.isEmpty) {
                  return const FetchingStudents(
                    text: "No quizzes have been conducted yet",
                  );
                }

                final allStudentIds = <String>{};
                for (var quiz in state.quizList) {
                  allStudentIds.addAll(quiz.studentmarks.keys);
                }
                final sortedStudentIds = allStudentIds.toList()..sort();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: DataTable(
                      // showCheckboxColumn: false,
                      headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Mulish'),
                      headingRowColor: WidgetStateColor.resolveWith(
                          (states) => Colors.grey.shade200),
                      dataRowColor: WidgetStateColor.resolveWith(
                          (states) => Colors.grey.shade50),
                      border: const TableBorder(
                          verticalInside: BorderSide(color: Colors.grey)),
                      horizontalMargin: 10,
                      columnSpacing: 20,
                      columns: [
                        const DataColumn(
                            headingRowAlignment: MainAxisAlignment.start,
                            label: Text(
                              'Name',
                            )),
                        ...state.quizList.map(
                          (quiz) => DataColumn(
                            label: Text(
                              '${quiz.quizName} (${quiz.totalMarks})\n${quiz.subject.toString().substring(0, 4)}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                      rows: sortedStudentIds.map((studentId) {
                        return DataRow(
                          cells: [
                            DataCell(Text(
                              studentId,
                              style: const TextStyle(
                                  fontFamily: "Mulish",
                                  fontWeight: FontWeight.bold),
                            )),
                            ...state.quizList.map((quiz) {
                              final marks = quiz.studentmarks[studentId] ?? '0';
                              return DataCell(
                                Center(
                                  child: Text(
                                    marks.toString(),
                                    style:
                                        const TextStyle(fontFamily: 'Fredoka'),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              } else if (state is QuizError) {
                return const Center(
                  child: Text("Error loading quizzes"),
                );
              }
              return const SizedBox();
            },
          );
        }),
      ),
    );
  }
}
