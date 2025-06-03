
import 'package:ahmed_academy/Data/Data%20Providers/student_data_provider.dart';
import 'package:ahmed_academy/Models/student.dart';

class StudentRepo {
  final StudentDataProvider studentDataProvider = StudentDataProvider();

  Future createStudent(Student s1) async {
    try {
      await studentDataProvider.createStudent(s1);
    } catch (e) {
      throw Exception("No Internet connection");
    }
  }

  Future<List<Student>> readStudentList(String classNo) async {
    try {
      print("---- Sending Request ----");
      List<Student> students =
          await studentDataProvider.readStudentList(classNo);
      print("Response Body: $students");
      print("\n---- Request Ended ----");

      return students;
    } catch (e) {
      throw Exception("No Internet connection");
    }
  }

  Future<List<Student>> readAllStudents() async {
    try {
      print("---- Sending Request ----");
      List<Student> students = await studentDataProvider.readAllStudents();
      print("Response Body: $students");
      print("\n---- Request Ended ----");

      return students;
    } catch (e) {
      throw Exception("No Internet connection");
    }
  }

  Future<bool> updateStudent(Student s1) async {
    try {
      print("---- Sending Update Request ----");
      bool result = await studentDataProvider.updateStudent(s1);
      print("Update Response: $result");
      print("\n---- Update Request Ended ----");

      return result;
    } catch (e) {
      throw Exception("No Internet connection");
    }
  }

  /// ✅ UPDATED DELETE FUNCTION
  Future<List<Student>> deleteStudent(Student s1) async {
    try {
      print("---- Sending Delete Request ----");
      final List result = await studentDataProvider.deleteStudent(s1);
      print("Delete Response: $result");
      print("\n---- Delete Request Ended ----");

      if (result.isNotEmpty) {
        // Fetch and return the updated student list after successful deletion
        return await readStudentList(s1.classNo);
      } else {
        return [];
      }
    } catch (e) {
      print("Error deleting student: $e");
      throw Exception("No Internet connection");
    }
  }
}
