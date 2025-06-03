import 'package:ahmed_academy/Logic/subjects_cubit.dart';
import 'package:ahmed_academy/Logic/student_bloc.dart';
import 'package:ahmed_academy/Models/student.dart';
import 'package:ahmed_academy/Settings/Widget/custom_bottom.dart';
import 'package:ahmed_academy/Settings/Widget/custom_button.dart';
import 'package:ahmed_academy/Settings/Widget/custom_popup.dart';
import 'package:ahmed_academy/Settings/Widget/custom_textfield.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_string/random_string.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController selectedClass = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController feePerSubjectController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feePerSubjectController.text = "1500";
  }

  Future<bool> checkFormCompletion(Map<String, bool> subjects) async {
    if (studentNameController.text.isEmpty ||
        contactNoController.text.isEmpty ||
        selectedClass.text.isEmpty ||
        feePerSubjectController.text.isEmpty ||
        !subjects.containsValue(true)) {
      print("Form Not complete");

      return true;
    } else {
      print("Form complete");

      return false;
    }
  }

  @override
  void dispose() {
    studentNameController.dispose();
    contactNoController.dispose();
    selectedClass.dispose();
    feePerSubjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Add Student Page");

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          "Add Student",
          style: TextStyle(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextfield(
                hintText: "Student Name",
                controller: studentNameController,
              ),
              CustomTextfield(
                hintText: "Contact No.",
                controller: contactNoController,
                keyboardType: const TextInputType.numberWithOptions(),
              ),
              CustomBottomSheet(
                controller: selectedClass,
                items: const ["Class 9", "Class 10", "Class 11", "Class 12"],
                hintText: "Select Class",
              ),
              MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => StudentBloc()),
                  BlocProvider(create: (context) => SubjectsCubit()),
                  BlocProvider(create: (context) => FeeCubit(0)),
                ],
                child: Builder(builder: (context) {
                  return BlocListener<StudentBloc, StudentState>(
                    listener: (context, state) {
                      if (state is FormNotCompleteState) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const CustomPopUp(type: PopUpType.formError),
                        );
                      } else if (state is ErrorState) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const CustomPopUp(type: PopUpType.error),
                        );
                      } else if (state is LoadingState) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const CustomPopUp(type: PopUpType.loading),
                        );
                      } else if (state is SuccessState) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const CustomPopUp(type: PopUpType.success),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 12, right: 12, top: 8, bottom: 0),
                          child: BlocBuilder<SubjectsCubit, Map<String, bool>>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Select Subjects",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  CheckboxListTile(
                                    activeColor:
                                        CustomTheme().selectedTextColor,
                                    title: const Text(
                                      "Maths",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: state["Maths"],
                                    onChanged: (value) {
                                      context
                                          .read<SubjectsCubit>()
                                          .updateSubject("Maths");
                                      context.read<FeeCubit>().calculateFees(
                                          context.read<SubjectsCubit>().state,
                                          int.parse(
                                              feePerSubjectController.text));
                                    },
                                  ),
                                  CheckboxListTile(
                                    activeColor:
                                        CustomTheme().selectedTextColor,
                                    title: const Text(
                                      "Physics",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: state["Physics"],
                                    onChanged: (value) {
                                      context
                                          .read<SubjectsCubit>()
                                          .updateSubject("Physics");
                                      context.read<FeeCubit>().calculateFees(
                                          context.read<SubjectsCubit>().state,
                                          int.parse(
                                              feePerSubjectController.text));
                                    },
                                  ),
                                  CheckboxListTile(
                                    activeColor:
                                        CustomTheme().selectedTextColor,
                                    title: const Text(
                                      "Chemistry",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: state["Chemistry"],
                                    onChanged: (value) {
                                      context
                                          .read<SubjectsCubit>()
                                          .updateSubject("Chemistry");
                                      context.read<FeeCubit>().calculateFees(
                                          context.read<SubjectsCubit>().state,
                                          int.parse(
                                              feePerSubjectController.text));
                                    },
                                  ),
                                  CheckboxListTile(
                                    activeColor:
                                        CustomTheme().selectedTextColor,
                                    title: const Text(
                                      "Computer",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: state["Computer"],
                                    onChanged: (value) {
                                      context
                                          .read<SubjectsCubit>()
                                          .updateSubject("Computer");
                                      context.read<FeeCubit>().calculateFees(
                                          context.read<SubjectsCubit>().state,
                                          int.parse(
                                              feePerSubjectController.text));
                                    },
                                  ),
                                  CheckboxListTile(
                                    activeColor:
                                        CustomTheme().selectedTextColor,
                                    title: const Text(
                                      "Biology",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: state["Biology"],
                                    onChanged: (value) {
                                      context
                                          .read<SubjectsCubit>()
                                          .updateSubject("Biology");
                                      context.read<FeeCubit>().calculateFees(
                                          context.read<SubjectsCubit>().state,
                                          int.parse(
                                              feePerSubjectController.text));
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  BlocBuilder<FeeCubit, int>(
                                    builder: (context, state) {
                                      return CustomTextfield(
                                        margin: const EdgeInsets.all(0),
                                        hintText: "Fee per Subject",
                                        controller: feePerSubjectController,
                                        onChanged: (value) {
                                          if (feePerSubjectController
                                              .text.isEmpty) {}
                                          context
                                              .read<FeeCubit>()
                                              .calculateFees(
                                                  context
                                                      .read<SubjectsCubit>()
                                                      .state,
                                                  int.parse(
                                                      feePerSubjectController
                                                          .text));
                                        },
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Total Fee:",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        BlocBuilder<FeeCubit, int>(
                                          builder: (context, state) {
                                            return Text(
                                              "Rs. ${context.read<FeeCubit>().state.toString()}",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.green[700],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        CustomElevatedButton(
                            text: "Submit",
                            onPressed: () async {
                              bool result = await checkFormCompletion(
                                  context.read<SubjectsCubit>().state);
                              if (!context.mounted) return;

                              if (result) {
                                context
                                    .read<StudentBloc>()
                                    .add(FormNotCompleteEvent());
                              } else {
                                String studentId = randomAlphaNumeric(9);

                                if (!context.mounted) return;

                                context.read<StudentBloc>().add(CreateStudent(
                                    Student(
                                        id: studentId,
                                        name: studentNameController.text,
                                        classNo: selectedClass.text,
                                        contactNo: contactNoController.text,
                                        subjects:
                                            context.read<SubjectsCubit>().state,
                                        feePerSubject: int.parse(
                                            feePerSubjectController.text),
                                        totalFees: int.parse(context
                                            .read<FeeCubit>()
                                            .state
                                            .toString()))));

                                studentNameController.clear();
                                contactNoController.clear();
                                context.read<SubjectsCubit>().clearSubject();
                              }
                            })
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
