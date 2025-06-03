import 'package:ahmed_academy/Logic/quiz_bloc.dart';
import 'package:ahmed_academy/Logic/student_bloc.dart';
import 'package:ahmed_academy/Models/quiz_model.dart';
import 'package:ahmed_academy/Settings/Widget/custom_bottom.dart';
import 'package:ahmed_academy/Settings/Widget/custom_button.dart';
import 'package:ahmed_academy/Settings/Widget/custom_popup.dart';
import 'package:ahmed_academy/Settings/Widget/custom_textfield.dart';
import 'package:ahmed_academy/Settings/Widget/error_widget.dart';
import 'package:ahmed_academy/Settings/Widget/fetching_students.dart';
import 'package:ahmed_academy/Settings/Widget/quiz_container.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadQuizMarks extends StatelessWidget {
  UploadQuizMarks({required this.classNo, super.key});

  final String classNo;
  final List marks = [];
  final TextEditingController controller = TextEditingController();
  final TextEditingController quizController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  bool _areFieldsFilled(BuildContext context) {
    if (controller.text.isEmpty || quizController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return const CustomPopUp(type: PopUpType.formError);
          });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Quiz Marks",
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StudentBloc()..add(ReadStudentList(classNo)),
          ),
          BlocProvider(
            create: (context) => QuizBloc(),
          ),
        ],
        child: Builder(builder: (context) {
          return BlocListener<QuizBloc, QuizState>(
            listener: (context, state) async {
              if (state is QuizUploading) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const CustomPopUp(type: PopUpType.loading);
                    });
              } else if (state is QuizUploaded) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const CustomPopUp(type: PopUpType.quizUploaded);
                    });
              } else if (state is QuizError) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const CustomPopUp(type: PopUpType.error);
                    });
              } else {
                PushNavigation.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocBuilder<StudentBloc, StudentState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const FetchingStudents();
                  } else if (state is ErrorState) {
                    return const CustomErrorWidget2();
                  } else {
                    if (state.studentsList.isEmpty) {
                      return CustomErrorWidget();
                    }

                    for (int i = 0; i < state.studentsList.length; i++) {
                      marks.add(0);
                    }
                    return Column(
                      spacing: 5,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                                flex: 4,
                                child: CustomTextfield(
                                    controller: quizController,
                                    margin: EdgeInsets.zero,
                                    hintText: "Quiz Name")),
                            Expanded(
                                flex: 3,
                                child: CustomTextfield(
                                    keyboardType: TextInputType.number,
                                    controller: totalController,
                                    margin: EdgeInsets.zero,
                                    hintText: "Total Marks")),
                          ],
                        ),
                        CustomBottomSheet(
                            margin: EdgeInsets.zero,
                            items: const [
                              "Physics",
                              "Chemistry",
                              "Biology",
                              "Computer"
                            ],
                            hintText: "Select Subject",
                            controller: controller),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.studentsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return QuizContainer(
                                  studentName: state.studentsList[index].name,
                                  initialMarks: 0,
                                  onMarksChanged: (value) {
                                    marks[index] = value;
                                  });
                            },
                          ),
                        ),
                        CustomElevatedButton(
                            text: "Submit",
                            onPressed: () {
                              if (_areFieldsFilled(context)) {
                                Map<String, dynamic> mergedMap =
                                    Map.fromIterables(
                                        state.studentsList
                                            .map((value) => value.name),
                                        marks);

                                context
                                    .read<QuizBloc>()
                                    .add(UploadQuizEvent(QuizModel(
                                      quizName: quizController.text,
                                      classNo: classNo,
                                      subject: controller.text,
                                      studentmarks: mergedMap,
                                      totalMarks:
                                          int.parse(totalController.text),
                                    )));
                              } else {
                                print("failed");
                              }
                            })
                      ],
                    );
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
