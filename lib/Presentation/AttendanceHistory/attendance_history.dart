import 'package:ahmed_academy/Logic/attendance_bloc.dart';
import 'package:ahmed_academy/Settings/Widget/error_widget.dart';
import 'package:ahmed_academy/Settings/Widget/fetching_students.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceHistory extends StatefulWidget {
  final String classNo;

  const AttendanceHistory({required this.classNo, super.key});

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  late AttendanceBloc attendanceBloc;

  @override
  void initState() {
    super.initState();
    attendanceBloc = AttendanceBloc();
    attendanceBloc.add(FetchAttendanceLastWeek(widget.classNo));
  }

  @override
  void dispose() {
    attendanceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Attendance History",
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
            Text(
              widget.classNo,
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
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        bloc: attendanceBloc,
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const FetchingStudents();
          } else if (state is AttendanceFailure) {
            return const CustomErrorWidget2();
          } else if (state is AttendanceFetched) {
            if (state.attendanceData.isEmpty) {
              return const CustomErrorWidget();
            } else {
              return _buildAttendanceList(state.attendanceData);
            }
          }
          return const Center(child: Text("No Data Available"));
        },
      ),
    );
  }

  Widget _buildAttendanceList(Map<String, Map<String, bool>> attendanceData) {
    List<String> dates = attendanceData.keys.toList()..sort();
    List<String> students = _getAllStudents(attendanceData);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row displaying dates
          const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '',
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Last 5 days",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Poppins'),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          // Students List
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                String student = students[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8.0),
                    // boxShadow: boxShadow != null ? [boxShadow!] : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Text(
                          student,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Mulish'),
                        ),
                      ),
                      ...dates.map((date) {
                        bool isPresent =
                            attendanceData[date]?[student] ?? false;
                        return Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPresent ? Colors.blue : Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                isPresent ? 'P' : 'A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Mulish",
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getAllStudents(Map<String, Map<String, bool>> attendanceData) {
    Set<String> studentNames = {};
    for (var record in attendanceData.values) {
      studentNames.addAll(record.keys);
    }
    return studentNames.toList();
  }
}
