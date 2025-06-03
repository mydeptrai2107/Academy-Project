import 'package:ahmed_academy/Presentation/Attendance/attendance.dart';
import 'package:ahmed_academy/Presentation/AttendanceHistory/attendance_history.dart';
import 'package:ahmed_academy/Presentation/ManageStudent/manage_student.dart';
import 'package:ahmed_academy/Presentation/QuizModule/quiz_review.dart';
import 'package:ahmed_academy/Presentation/QuizModule/upload_quiz_marks.dart';
import 'package:ahmed_academy/Settings/Widget/container_with_text.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';

class ClassList extends StatelessWidget {
  const ClassList({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
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
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        scrolledUnderElevation: 0,
        shadowColor: Colors.black,
        backgroundColor: CustomTheme().selectedTextColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if (title == "Attendance") {
                  PushNavigation.push(
                      context,
                      Attendance(
                        classNo: "Class ${index + 9}",
                      ));
                } else if (title == "Attendance History") {
                  PushNavigation.push(
                      context,
                      AttendanceHistory(
                        classNo: "Class ${index + 9}",
                      ));
                } else if (title == "Manage Student") {
                  PushNavigation.push(
                      context,
                      ManageStudent(
                        classNo: "Class ${index + 9}",
                      ));
                } else if (title == "Upload Quiz Marks") {
                  PushNavigation.push(
                      context,
                      UploadQuizMarks(
                        classNo: "Class ${index + 9}",
                      ));
                } else if (title == "Quiz Review") {
                  PushNavigation.push(
                      context,
                      QuizReview(
                        classNo: "Class ${index + 9}",
                      ));
                }
              },
              child: ContainerWithText(
                text: "Class ${index + 9}",
                boxShadow: BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 1.0,
                  offset: const Offset(1, 2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
