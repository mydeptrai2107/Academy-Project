import 'package:ahmed_academy/Data/Data%20Providers/attendance_provider.dart';

class AttendanceRepo {
  final AttendanceProvider attendanceProvider = AttendanceProvider();

  Future<String> markAttendance(
      String classNo, String date, Map<String, bool> students) async {
    try {
      print("---- Sending Request ----");
      print("Body: {$classNo, $date, $students}");
      await attendanceProvider.markAttendance(classNo, date, students);
      print("\n---- Request Ended ----");
      return 'Success';
    } catch (e) {
      print("Error: $e");
      throw e.toString();
    }
  }

  Future<Map<String, Map<String, bool>>> fetchAttendanceLastWeek(
      String classNo) async {
    try {
      print("---- Fetching Attendance for Last Week ----");
      Map<String, Map<String, bool>> attendanceData =
          await attendanceProvider.fetchAttendanceLastWeek(classNo);

      print("Body: $attendanceData");
      print("\n---- Fetch Completed ----");
      return attendanceData;
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to fetch attendance. Please try again.");
    }
  }
}
