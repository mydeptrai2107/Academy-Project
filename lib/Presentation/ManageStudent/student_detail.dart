import 'package:ahmed_academy/Models/student.dart';
import 'package:ahmed_academy/Presentation/ManageStudent/edit_student.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDetail extends StatefulWidget {
  const StudentDetail({required this.student, super.key});

  final Student student;

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
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
              widget.student.name,
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: CustomTheme().selectedTextColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.edit_note_rounded),
          onPressed: () async {
            await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        EditStudent(student: widget.student)));

            setState(() {});
          }),
      body: ListView(
        children: [
          _buildDetailCard(
            icon: LucideIcons.user,
            title: "Student Name",
            value: widget.student.name,
          ),
          _buildDetailCard(
            icon: LucideIcons.phone,
            title: "Contact Number",
            value: widget.student.contactNo,
            extension: GestureDetector(
              onTap: () async {
                final Uri phoneUri =
                    Uri(scheme: 'tel', path: widget.student.contactNo);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  print("Could not launch the dialer");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CustomTheme().selectedTextColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Dial Now",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Mulish',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          _buildDetailCard(
            icon: LucideIcons.book,
            title: "Class",
            value: widget.student.classNo,
          ),
          _buildSubjectsCard(),
          _buildDetailCard(
            icon: LucideIcons.badgeDollarSign,
            title: "Fee Per Subject",
            value: "${widget.student.feePerSubject} PKR",
          ),
          _buildDetailCard(
            icon: LucideIcons.wallet,
            title: "Total Fees",
            value: "${widget.student.totalFees} PKR",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
      {required IconData icon,
      required String title,
      required String value,
      Widget? extension}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: CustomTheme().selectedTextColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (extension != null) extension
        ],
      ),
    );
  }

  Widget _buildSubjectsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.bookOpen,
                  color: CustomTheme().selectedTextColor),
              const SizedBox(width: 16),
              const Text(
                "Subjects",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...widget.student.subjects.entries.map((entry) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                    ),
                  ),
                  Icon(
                    entry.value ? Icons.check_circle : Icons.cancel,
                    color: entry.value ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
