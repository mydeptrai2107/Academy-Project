import 'dart:async';
import 'package:ahmed_academy/Models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StudentDataProvider {
  Future readData() async {}

  Future<bool> createStudent(Student student) async {
    try {
      print("----------------- Creating Student -----------------");
      print(
          "Body: {${student.name}, ${student.classNo}, ${student.subjects}, ${student.totalFees}}");

      await FirebaseFirestore.instance
          .collection("classes")
          .doc(student.classNo)
          .collection("students")
          .doc(student.id)
          .set(student.toJson())
          .timeout(const Duration(seconds: 10));

      print("----------------- Student Created Successfully -----------------");

      final studentMap = {
        "studentName": student.name,
        "studentId": student.id,
        "amount": student.totalFees,
        "isFeesPaid": false,
        "classNo": student.classNo
      };

      await FirebaseFirestore.instance
          .collection("FeeStatus")
          .doc(DateFormat('MMM-yyyy').format(DateTime.now()))
          .set({student.id: studentMap}, SetOptions(merge: true)).timeout(
              const Duration(seconds: 10));

      print("----------------- Student Fee Status Added -----------------");
      return true;
    } catch (e) {
      print("----------------- Error creating student: $e -----------------");
      throw TimeoutException("Request to Firestore timed out");
    }
  }

  Future<bool> updateStudent(Student student) async {
    try {
      print("----------------- Updating Student -----------------");
      print(
          "Updated Body: {${student.id}, ${student.name}, ${student.classNo}, ${student.subjects}, ${student.totalFees}}");

      await FirebaseFirestore.instance
          .collection("classes")
          .doc(student.classNo)
          .collection("students")
          .doc(student.id)
          .update(student.toJson())
          .timeout(const Duration(seconds: 10));

      print("----------------- Student Details Updated -----------------");

      final studentMap = {
        "studentName": student.name,
        "studentId": student.id,
        "amount": student.totalFees,
        "isFeesPaid": false,
        "classNo": student.classNo
      };

      await FirebaseFirestore.instance
          .collection("FeeStatus")
          .doc(DateFormat('MMM-yyyy').format(DateTime.now()))
          .update({student.id: studentMap}).timeout(
              const Duration(seconds: 10));

      print("----------------- Student Fee Status Updated -----------------");
      return true;
    } catch (e) {
      print(
          "------------------ Error updating student: $e --------------------");

      throw Exception("Error $e");
    }
  }

  Future<List<Student>> readStudentList(String classNo) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classNo)
          .collection("students")
          .get()
          .timeout(const Duration(seconds: 5));

      List<Student> students = querySnapshot.docs
          .map((doc) => Student.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return students;
    } catch (e) {
      print("Timeout error: $e");
      throw Exception("Request to Firestore timed out");
    }
  }

  Future<List<Student>> readAllStudents() async {
    try {
      List<String> classes = ["9", "10", "11", "12"];
      List<Student> allStudents = [];

      for (var classNo in classes) {
        QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
            .collection("classes")
            .doc("Class $classNo")
            .collection("students")
            .get()
            .timeout(const Duration(seconds: 5));

        List<Student> students = studentSnapshot.docs
            .map((doc) => Student.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        allStudents.addAll(students);
      }

      print("Successfully retrieved all students from all classes!");
      return allStudents;
    } catch (e) {
      print("Error reading student data: $e");
      throw Exception("No Internet connection");
    }
  }

  Future<List<Student>> deleteStudent(Student student) async {
    try {
      print("----------------- Deleting Student -----------------");
      print("Deleting student with ID: ${student.id}");

      // Delete from 'students' collection
      await FirebaseFirestore.instance
          .collection("classes")
          .doc(student.classNo)
          .collection("students")
          .doc(student.id)
          .delete()
          .timeout(const Duration(seconds: 10));

      print(
          "----------------- Student Deleted from Class ${student.classNo} -----------------");

      // Delete from 'FeeStatus' collection
      await FirebaseFirestore.instance
          .collection("FeeStatus")
          .doc(student.id)
          .delete()
          .timeout(const Duration(seconds: 10));

      print("----------------- Student Fee Status Deleted -----------------");

      // Fetch the updated list of students using the existing function
      return await readStudentList(student.classNo);
    } catch (e) {
      print(
          "------------------ Error deleting student: $e --------------------");
      throw Exception("No Internet connection");
    }
  }
}
