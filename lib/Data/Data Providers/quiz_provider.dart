import 'dart:io'; // For SocketException
import 'package:ahmed_academy/Models/quiz_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadQuizToFirebase(QuizModel quiz) async {
    try {
      final quizRef =
          _firestore.collection('Quizzes').doc(quiz.classNo).collection("quiz");

      await quizRef.doc().set({
        'quizName': quiz.quizName,
        'totalMarks': quiz.totalMarks,
        'classNo': quiz.classNo,
        'students': quiz.studentmarks,
        'subject': quiz.subject
      });
    } on SocketException {
      throw Exception(
          "No internet connection. Please check your network and try again.");
    } on FirebaseException {
      throw Exception(
          "Failed to upload quiz due to Firestore error: \${e.message}");
    } catch (e) {
      throw Exception("Failed to upload quiz due to an unexpected error.");
    }
  }

  Future<List<QuizModel>> fetchQuizzesForClass(String classNo) async {
    try {
      final quizRef =
          _firestore.collection('Quizzes').doc(classNo).collection("quiz");

      final querySnapshot = await quizRef.get();

      List<QuizModel> quizzes = querySnapshot.docs.map((doc) {
        return QuizModel(
          quizName: doc['quizName'],
          totalMarks: doc['totalMarks'],
          classNo: doc['classNo'],
          subject: doc['subject'],
          studentmarks: Map<String, dynamic>.from(doc['students'] as Map),
        );
      }).toList();

      return quizzes;
    } on SocketException {
      throw Exception(
          "No internet connection. Please check your network and try again.");
    } on FirebaseException {
      throw Exception(
          "Failed to fetch quizzes due to Firestore error: \${e.message}");
    } catch (e) {
      throw Exception("Failed to fetch quizzes due to an unexpected error.");
    }
  }
}
