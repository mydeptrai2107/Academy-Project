import 'package:ahmed_academy/Presentation/ManageStudent/add_student.dart';
import 'package:ahmed_academy/Presentation/ClassList/class_list.dart';
import 'package:ahmed_academy/Presentation/FeeStatus/fee_months_page.dart';
import 'package:ahmed_academy/Presentation/FeeStatus/fee_status.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> gridList = [
    {
      "title": "Add Student",
      "image": "assets/images/new-student.png",
      'link': const AddStudent()
    },
    {
      "title": "Manage Student",
      "image": "assets/images/manage.png",
      'link': const ClassList(title: "Manage Student")
    },
    {
      "title": "Mark Attendance",
      "image": "assets/images/attendance.png",
      'link': const ClassList(title: "Attendance")
    },
    {
      "title": "Attendance History",
      "image": "assets/images/attendance history.png",
      'link': const ClassList(title: "Attendance History")
    },
    {
      "title": "Fee Status",
      "image": "assets/images/fees.png",
      'link': const FeeStatus()
    },
    {
      "title": "Fee History",
      "image": "assets/images/fee-history.png",
      'link': const FeeMonthsPage()
    },
    {
      "title": "Upload Quiz Marks",
      "image": "assets/images/quiz.png",
      'link': const ClassList(
        title: "Upload Quiz Marks",
      )
    },
    {
      "title": "Quiz Review",
      "image": "assets/images/quiz2.png",
      'link': const ClassList(
        title: "Quiz Review",
      )
    },
  ];

  Future<void> startNewSession() async {
    // TODO: Replace the following with actual logic
    // Example: Delete collections from Firebase
    // await FirebaseFirestore.instance.collection('FeeStatus').get().then((snapshot) {
    //   for (var doc in snapshot.docs) {
    //     doc.reference.delete();
    //   }
    // });

    await Future.delayed(const Duration(seconds: 2)); // Simulate delay
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Fredoka', fontSize: 14),
              ),
              Text(
                "Ahmed Academy",
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              )
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.settings_rounded, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Start New Session"),
                    content: const Text(
                      "Are you sure you want to start a new session? This will delete all data from the previous year.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(); // Close the dialog

                          // Optional: show loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          await startNewSession(); // Perform deletion or reset

                          if (!context.mounted) return;
                          Navigator.of(context).pop(); // Close loading

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("New session started successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
        toolbarHeight: 80,
        titleSpacing: 0,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        backgroundColor: CustomTheme().selectedTextColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: gridList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio: 1.3,
              // crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  PushNavigation.push(context, gridList[index]['link']);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        blurRadius: 1.0,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        gridList[index]['image']!,
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        gridList[index]['title']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
