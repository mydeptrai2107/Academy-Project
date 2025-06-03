import 'package:ahmed_academy/Data/Data%20Providers/quiz_provider.dart';
import 'package:ahmed_academy/Models/quiz_model.dart';

class QuizRepo {
  QuizProvider quizProvider = QuizProvider();

  uploadQuizMarks(QuizModel quiz) async {
    try {
      print("---- Sending Request ----");
      await quizProvider.uploadQuizToFirebase(quiz);
      print("\n---- Request Ended ----");
    } catch (e) {
      print("Error: $e");
    }
  }

  fetchQuizMarks(String classNo) async {
    try {
      print("---- Sending Request ----");
      final quizList = await quizProvider.fetchQuizzesForClass(classNo);
      print("\n---- Request Ended ----");
      return quizList;
    } catch (e) {
      print("Error: $e");
    }
  }
}
