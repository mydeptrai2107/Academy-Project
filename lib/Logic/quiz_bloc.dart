import 'package:ahmed_academy/Data/Repository/quiz_repo.dart';
import 'package:ahmed_academy/Models/quiz_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ===================== EVENTS =====================
abstract class QuizEvent {
  const QuizEvent();
}

class UploadQuizEvent extends QuizEvent {
  final QuizModel quiz;

  const UploadQuizEvent(this.quiz);
}

class FetchQuizEvent extends QuizEvent {
  final String classNo;
  FetchQuizEvent(this.classNo);
}

// ===================== STATES =====================
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizUploading extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuizModel> quizList;

  QuizLoaded({required this.quizList});
}

class QuizUploaded extends QuizState {}

class QuizFormNotComplete extends QuizState {}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}

// ===================== BLOC =====================
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<UploadQuizEvent>((event, emit) async {
      emit(QuizUploading());

      try {
        await QuizRepo().uploadQuizMarks(event.quiz);

        emit(QuizInitial());
        emit(QuizUploaded());
        await Future.delayed(const Duration(seconds: 1));
        emit(QuizInitial());
      } catch (e) {
        emit(QuizInitial());
        emit(QuizError("Failed to upload quiz: $e"));
        await Future.delayed(const Duration(seconds: 1));
        emit(QuizInitial());
      }
    });

    on<FetchQuizEvent>((event, emit) async {
      emit(QuizLoading());

      try {
        final quizList = await QuizRepo().fetchQuizMarks(event.classNo);
        emit(QuizLoaded(quizList: quizList));
      } catch (e) {
        emit(QuizError("Failed to upload quiz: $e"));
        await Future.delayed(const Duration(seconds: 1));
      }
    });
  }
}

// ===================== HOW TO USE (UI) =====================
//
// final quizBloc = QuizBloc(firestore: FirebaseFirestore.instance);
//
// BlocProvider(
//   create: (context) => quizBloc,
//   child: BlocConsumer<QuizBloc, QuizState>(
//     listener: (context, state) {
//       if (state is QuizUploaded) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("✅ Quiz uploaded successfully!")),
//         );
//       } else if (state is QuizError) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ ${state.message}")),
//         );
//       }
//     },
//     builder: (context, state) {
//       if (state is QuizUploading) {
//         return Center(child: CircularProgressIndicator());
//       }
//       return UploadQuizMarks(); // Your page widget
//     },
//   ),
// );
//
// To trigger upload:
// quizBloc.add(UploadQuizEvent(quizModel));
