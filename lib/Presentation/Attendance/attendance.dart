import 'package:ahmed_academy/Logic/attendance_bloc.dart';
import 'package:ahmed_academy/Logic/student_bloc.dart';
import 'package:ahmed_academy/Settings/Widget/attendance_container.dart';
import 'package:ahmed_academy/Settings/Widget/custom_button.dart';
import 'package:ahmed_academy/Settings/Widget/custom_popup.dart';
import 'package:ahmed_academy/Settings/Widget/error_widget.dart';
import 'package:ahmed_academy/Settings/Widget/fetching_students.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  const Attendance({required this.classNo, super.key});

  final String classNo;

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final StudentBloc studentBloc = StudentBloc();
  final AttendanceBloc attendanceBloc = AttendanceBloc();

  ValueNotifier<Map<String, bool>> studentAttendanceNotifier =
      ValueNotifier<Map<String, bool>>({});

  ValueNotifier<String> selectedDate =
      ValueNotifier(DateFormat('dd-MMM').format(DateTime.now()).toString());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    studentBloc.close();
    attendanceBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Attendance",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              widget.classNo,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Mulish', fontSize: 14),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                ),
                Text(
                  selectedDate.value,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Mulish', fontSize: 10),
                )
              ],
            ),
          )
        ],
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
        shadowColor: Colors.black,
        backgroundColor: CustomTheme().selectedTextColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: BlocListener<AttendanceBloc, AttendanceState>(
        bloc: attendanceBloc,
        listener: (context, attendanceState) {
          if (attendanceState is AttendanceFailure) {
            showDialog(
              context: context,
              builder: (context) =>
                  const CustomPopUp(type: PopUpType.attendanceError),
            );
          } else if (attendanceState is AttendanceLoading) {
            showDialog(
              context: context,
              builder: (context) =>
                  const CustomPopUp(type: PopUpType.attendanceLoading),
            );
          } else if (attendanceState is AttendanceSuccess) {
            showDialog(
              context: context,
              builder: (context) =>
                  const CustomPopUp(type: PopUpType.attendanceSuccess),
            );
          } else if (attendanceState is AttendanceInitial) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<StudentBloc, StudentState>(
          bloc: studentBloc,
          builder: (context, state) {
            if (state is LoadingState) {
              return const FetchingStudents();
            } else if (state is ErrorState) {
              return CustomErrorWidget2(
                message: state.message,
              );
            } else if (state is SuccessState) {
              return const Center(child: Text("Attendance Already Marked"));
            } else {
              for (var value in state.studentsList) {
                studentAttendanceNotifier.value[value.name] =
                    value.isPresent ?? true;
              }

              return state.studentsList.isEmpty
                  ? const CustomErrorWidget()
                  : Column(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<Map<String, bool>>(
                            valueListenable: studentAttendanceNotifier,
                            builder: (context, studentAttendance, _) {
                              return ListView.builder(
                                itemCount: state.studentsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AttendanceContainer(
                                    studentName: state.studentsList[index].name,
                                    isPresent: studentAttendance[
                                        state.studentsList[index].name]!,
                                    onToggle: () {
                                      studentAttendanceNotifier.value = {
                                        ...studentAttendanceNotifier.value,
                                        state.studentsList[index].name:
                                            !studentAttendanceNotifier.value[
                                                state.studentsList[index].name]!
                                      };
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        CustomElevatedButton(
                          text: 'Mark Attendance',
                          onPressed: () {
                            attendanceBloc.add(MarkAAttendance(
                                widget.classNo,
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                studentAttendanceNotifier.value));
                          },
                        )
                      ],
                    );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    studentBloc.add(ReadStudentList(widget.classNo));
  }
}
