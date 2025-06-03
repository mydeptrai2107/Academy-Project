import 'package:ahmed_academy/Data/Repository/attendance_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define Events
abstract class AttendanceEvent {}

class MarkAAttendance extends AttendanceEvent {
  final String classNo;
  final String date;
  final Map<String, bool> students;

  MarkAAttendance(this.classNo, this.date, this.students);
}

class FetchAttendanceLastWeek extends AttendanceEvent {
  final String classNo;

  FetchAttendanceLastWeek(this.classNo);
}

// Define States
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final String message;
  AttendanceSuccess(this.message);
}

class AttendanceFailure extends AttendanceState {
  final String error;
  AttendanceFailure(this.error);
}

class AttendanceFetched extends AttendanceState {
  final Map<String, Map<String, bool>> attendanceData;

  AttendanceFetched(this.attendanceData);
}

// Define Bloc
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceInitial()) {
    ///////////////////////////////////      Mark Attendnace      ///////////////////////////////////////////////////////

    on<MarkAAttendance>((event, emit) async {
      try {
        emit(AttendanceLoading());
        await AttendanceRepo()
            .markAttendance(event.classNo, event.date, event.students);

        emit(AttendanceInitial());
        emit(AttendanceSuccess("Attendance Marked!"));
      } catch (e) {
        emit(AttendanceInitial());
        emit(AttendanceFailure("Failure with Attendance"));
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(AttendanceInitial());
    });

    ///////////////////////////////////       Fetch Attendnace      ///////////////////////////////////////////////////////

    on<FetchAttendanceLastWeek>((event, emit) async {
      try {
        emit(AttendanceLoading());
        Map<String, Map<String, bool>> attendanceData =
            await AttendanceRepo().fetchAttendanceLastWeek(event.classNo);

        emit(AttendanceFetched(attendanceData));
      } catch (e) {
        emit(AttendanceFailure("Failed to fetch attendance"));
      }
    });
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(error, stackTrace);
    print(error);
  }

  // @override
  // void onChange(Change<AttendanceState> change) {
  //   super.onChange(change);
  //   print(change);
  // }
}
