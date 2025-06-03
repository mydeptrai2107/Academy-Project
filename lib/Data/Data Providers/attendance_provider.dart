import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AttendanceProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markAttendance(
      String classNo, String date, Map<String, bool> students) async {
    try {
      DocumentReference docRef = _firestore
          .collection("Attendance")
          .doc(classNo)
          .collection(date)
          .doc("students");

      await Future.any([
        docRef.set(students, SetOptions(merge: true)),
        Future.delayed(const Duration(seconds: 10), () {
          throw TimeoutException("Request timed out. Please try again.");
        }),
      ]);

      print("Attendance Successfully Marked");
    } on TimeoutException catch (e) {
      print("Timeout Error: \${e.message}");
      throw Exception(e.message);
    } on FirebaseException {
      print("Firebase Error: \${e.message}");
      throw Exception("Failed to mark attendance. Please try again.");
    } catch (e) {
      print("Unexpected Error: $e");
      throw Exception("Something went wrong while marking attendance.");
    }
  }

  Future<Map<String, Map<String, bool>>> fetchAttendanceLastWeek(
      String classNo) async {
    try {
      Map<String, Map<String, bool>> attendanceRecords = {};
      DateTime now = DateTime.now();
      for (int i = 0; i < 5; i++) {
        String date =
            DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));
        DocumentSnapshot docSnap = await _firestore
            .collection("Attendance")
            .doc(classNo)
            .collection(date)
            .doc("students")
            .get()
            .timeout(const Duration(seconds: 10));

        if (docSnap.exists) {
          attendanceRecords[date] =
              Map<String, bool>.from(docSnap.data() as Map);
        }
      }

      print(attendanceRecords);

      return attendanceRecords;
    } on FirebaseException {
      print("Firebase Error: \${e.message}");
      throw Exception("Failed to fetch attendance. Please try again.");
    } catch (e) {
      print("Unexpected Error: $e");
      throw Exception("Something went wrong while fetching attendance.");
    }
  }
}
