import 'dart:async';
import 'dart:io';
import 'package:ahmed_academy/Data/Repository/student_repo.dart';
import 'package:ahmed_academy/Models/student.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class StudentEvent {}

final class CreateStudent extends StudentEvent {
  final Student student;
  CreateStudent(this.student);
}

final class ReadStudent extends StudentEvent {
  final Student student;
  ReadStudent(this.student);
}

final class ReadStudentList extends StudentEvent {
  final String classNo;
  ReadStudentList(this.classNo);
}

final class ReadAllStudents extends StudentEvent {
  ReadAllStudents();
}

final class DeleteStudent extends StudentEvent {
  final Student student;
  DeleteStudent(this.student);
}

final class UpdateStudent extends StudentEvent {
  final Student student;
  UpdateStudent(this.student);
}

final class MarkAttendance extends StudentEvent {
  final String classNo;
  final String date;
  final Map<String, bool> students;

  MarkAttendance(this.classNo, this.date, this.students);
}

final class FetchAttendance extends StudentEvent {
  final String classNo;
  final String date;

  FetchAttendance(this.classNo, this.date);
}

final class FormNotCompleteEvent extends StudentEvent {}

class StudentState {
  StudentState({this.studentsList = const []});
  List<Student> studentsList = [];
}

class LoadingState extends StudentState {}

class DeletingState extends StudentState {}

class EmptyListState extends StudentState {}

class ErrorState extends StudentState {
  ErrorState({required this.message});
  final String message;
}

class SuccessState extends StudentState {}

class StudentsLoadedState extends StudentState {}

class FormNotCompleteState extends StudentState {}

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentState()) {
    on<CreateStudent>((event, emit) async {
      emit(LoadingState());
      try {
        await StudentRepo().createStudent(event.student);
        emit(StudentState());
        emit(SuccessState());
      } on SocketException {
        emit(StudentState());
        emit(ErrorState(message: "No Internet Connection"));
      } catch (e) {
        emit(StudentState());
        emit(ErrorState(
            message: "Oops! An error occurred. Please try again later."));
      } finally {
        await Future.delayed(const Duration(seconds: 1));
        emit(StudentState());
      }
    });

    on<FormNotCompleteEvent>((event, emit) async {
      emit(FormNotCompleteState());
      await Future.delayed(const Duration(seconds: 1));
      emit(StudentState());
    });

    on<ReadStudentList>((event, emit) async {
      try {
        emit(LoadingState());
        final List<Student> studentsList =
            await StudentRepo().readStudentList(event.classNo);
        emit(StudentState(studentsList: studentsList));
      } on SocketException {
        emit(ErrorState(
            message: "No Internet connection. Please try again later."));
      } catch (e) {
        emit(ErrorState(message: "Oops! An error occured. Please try later."));
      }
    });

    on<ReadAllStudents>((event, emit) async {
      emit(LoadingState());

      try {
        final List<Student> studentsList =
            await StudentRepo().readAllStudents();
        print("Student List: $studentsList");

        emit(StudentState(studentsList: studentsList));
      } on SocketException {
        emit(ErrorState(
            message:
                "No Internet connection. Please check your network and try again."));
      } catch (e) {
        emit(ErrorState(message: "An unexpected error occurred: $e"));
      }
    });

    on<UpdateStudent>((event, emit) async {
      try {
        emit(LoadingState());
        print("---- Sending Update Request ----");
        bool result = await StudentRepo().updateStudent(event.student);
        emit(StudentState());
        emit(SuccessState());
        print("Update Response: $result");
        print("\n---- Update Request Ended ----");
        await Future.delayed(const Duration(seconds: 1));
        emit(StudentState());
        emit(StudentState());
      } catch (e) {
        emit(ErrorState(message: "Unexpected Error"));
        throw const SocketException("No Internet connection");
      }
    });

    on<DeleteStudent>((event, emit) async {
      try {
        emit(DeletingState());
        print(state.studentsList);
        print("---- Sending Delete Request ----");

        final List<Student> updatedList =
            await StudentRepo().deleteStudent(event.student);
        print("Delete Response: $updatedList");
        print("\n---- Delete Request Ended ----");

        print(state.studentsList);

        emit(StudentState(studentsList: updatedList)); // Success state
      } catch (e) {
        print("Error deleting student: $e");
        emit(ErrorState(
            message:
                "Oops! An error occured. Please try later.")); // Optional: Handle network errors
      }
    });
  }

  @override
  void onChange(Change<StudentState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
}
