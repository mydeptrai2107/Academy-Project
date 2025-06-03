import 'package:ahmed_academy/Logic/student_bloc.dart';
import 'package:ahmed_academy/Presentation/ManageStudent/student_detail.dart';
import 'package:ahmed_academy/Settings/Widget/container_with_text.dart';
import 'package:ahmed_academy/Settings/Widget/error_widget.dart';
import 'package:ahmed_academy/Settings/Widget/fetching_students.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageStudent extends StatefulWidget {
  const ManageStudent({required this.classNo, super.key});

  final String classNo;

  @override
  State<ManageStudent> createState() => _ManageStudentState();
}

class _ManageStudentState extends State<ManageStudent> {
  final StudentBloc studentBloc = StudentBloc();

  @override
  void initState() {
    super.initState();
    studentBloc.add(ReadStudentList(widget.classNo));
  }

  @override
  void dispose() {
    studentBloc.close();
    super.dispose();
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
              "Manage Students",
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
      body: BlocBuilder(
        bloc: studentBloc,
        builder: (context, state) {
          if (state is LoadingState) {
            return const FetchingStudents();
          } else if (state is SuccessState) {
            return const Text("Successful");
          } else if (state is DeletingState) {
            return const Updating();
          } else if (state is ErrorState) {
            return const CustomErrorWidget2();
          } else if (state is StudentState) {
            // print("Ithey");
            if (studentBloc.state.studentsList.isEmpty) {
              return const CustomErrorWidget();
            } else {
              return Center(
                child: ListView.builder(
                  itemCount: studentBloc.state.studentsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        PushNavigation.push(
                            context,
                            StudentDetail(
                                student:
                                    studentBloc.state.studentsList[index]));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ContainerWithText(
                                margin: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 12, right: 0),
                                text:
                                    studentBloc.state.studentsList[index].name),
                          ),
                          IconButton(
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent dismiss on outside tap
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      width: 250,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withAlpha(177),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                              Icons.warning_amber_rounded,
                                              size: 60,
                                              color: Colors.red),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Are you sure you want to delete ${studentBloc.state.studentsList[index].name}?",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context,
                                                      true); // Return true if confirmed
                                                },
                                                child: const Text("Yes"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  foregroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context,
                                                      false); // Return false if canceled
                                                },
                                                child: const Text("No"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ).then((confirmed) async {
                                if (confirmed == true) {
                                  studentBloc.add(DeleteStudent(
                                      studentBloc.state.studentsList[index]));
                                } else {
                                  print("Deletion canceled.");
                                }
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return const Text("Unexpected");
          }
        },
      ),
    );
  }
}
