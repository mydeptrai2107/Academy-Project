
class QuizModel {
  String quizName;
  String subject;
  int totalMarks;
  String classNo;
  Map<String, dynamic> studentmarks;

  QuizModel(
      {required this.quizName,
      required this.totalMarks,
      required this.classNo,
      required this.subject,
      required this.studentmarks});
}
