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

class EditStudent extends StatefulWidget {
  final Student student;
  const EditStudent({super.key, required this.student});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  late TextEditingController selectedClass;
  late TextEditingController studentNameController;
  late TextEditingController contactNoController;
  late TextEditingController feePerSubjectController;

  @override
  void initState() {
    super.initState();
    studentNameController = TextEditingController(text: widget.student.name);
    contactNoController = TextEditingController(text: widget.student.contactNo);
    selectedClass = TextEditingController(text: widget.student.classNo);
    feePerSubjectController =
        TextEditingController(text: widget.student.feePerSubject.toString());
  }

  Future<bool> checkFormCompletion(Map<String, bool> subjects) async {
    return studentNameController.text.isEmpty ||
        contactNoController.text.isEmpty ||
        selectedClass.text.isEmpty ||
        feePerSubjectController.text.isEmpty ||
        !subjects.containsValue(true);
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          "Edit Student",
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
        backgroundColor: CustomTheme().selectedTextColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => StudentBloc()),
              BlocProvider(
                create: (context) =>
                    SubjectsCubit()..setSubjects(widget.student.subjects),
              ),
              BlocProvider(
                create: (context) => FeeCubit(widget.student.totalFees),
              ),
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
                  } else if (state is LoadingState) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const CustomPopUp(type: PopUpType.loading),
                    );
                  } else if (state is ErrorState) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const CustomPopUp(type: PopUpType.error),
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
                      selectedValue: selectedClass.text,
                      controller: selectedClass,
                      items: const [
                        "Class 9",
                        "Class 10",
                        "Class 11",
                        "Class 12"
                      ],
                      hintText: "Select Class",
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 12, right: 12, top: 8, bottom: 0),
                      child: Column(
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
                          BlocBuilder<SubjectsCubit, Map<String, bool>>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.keys.map((subject) {
                                  return CheckboxListTile(
                                    activeColor:
                                        CustomTheme().selectedTextColor,
                                    title: Text(
                                      subject,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: state[subject],
                                    onChanged: (value) {
                                      context
                                          .read<SubjectsCubit>()
                                          .updateSubject(subject);
                                      context.read<FeeCubit>().calculateFees(
                                          state,
                                          int.parse(
                                              feePerSubjectController.text));
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<FeeCubit, int>(
                      builder: (context, state) {
                        return CustomTextfield(
                          hintText: "Fee per Subject",
                          controller: feePerSubjectController,
                          onChanged: (value) {
                            context.read<FeeCubit>().calculateFees(
                                context.read<SubjectsCubit>().state,
                                int.tryParse(value) ?? 0);
                          },
                          keyboardType: const TextInputType.numberWithOptions(),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(
                          left: 14, right: 14, top: 2, bottom: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                "Rs. $state",
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
                    CustomElevatedButton(
                      text: "Update",
                      onPressed: () async {
                        bool isIncomplete = await checkFormCompletion(
                            context.read<SubjectsCubit>().state);
                        if (!context.mounted) return;

                        if (isIncomplete) {
                          context
                              .read<StudentBloc>()
                              .add(FormNotCompleteEvent());
                        } else {
                          widget.student.name = studentNameController.text;
                          widget.student.classNo = selectedClass.text;
                          widget.student.contactNo = contactNoController.text;
                          widget.student.subjects =
                              context.read<SubjectsCubit>().state;
                          widget.student.feePerSubject =
                              int.parse(feePerSubjectController.text);
                          widget.student.totalFees =
                              context.read<FeeCubit>().state;

                          context.read<StudentBloc>().add(UpdateStudent(Student(
                              id: widget.student.id,
                              name: studentNameController.text,
                              classNo: selectedClass.text,
                              contactNo: contactNoController.text,
                              subjects: context.read<SubjectsCubit>().state,
                              feePerSubject:
                                  int.parse(feePerSubjectController.text),
                              totalFees: context.read<FeeCubit>().state)));
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
