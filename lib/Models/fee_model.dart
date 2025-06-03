import 'package:cloud_firestore/cloud_firestore.dart';

class FeeModel {
  String studentName;
  String id;
  bool isFeesPaid;
  int amount;
  String classNo;
  bool isChanged;
  DateTime feeDate; // New property

  FeeModel({
    required this.id,
    required this.studentName,
    required this.isFeesPaid,
    required this.amount,
    required this.classNo,
    required this.feeDate, // Initialize in constructor
    this.isChanged = false,
  });

  void toggleStatus() {
    isFeesPaid = !isFeesPaid;
    isChanged = true;
  }

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'classNo': classNo,
      'isFeesPaid': isFeesPaid,
      'amount': amount,
      'feeDate': Timestamp.fromDate(
          feeDate), // Convert DateTime to Firestore Timestamp
    };
  }

  factory FeeModel.fromFirebaseMap(String id, Map<String, dynamic> data) {
    return FeeModel(
      id: id,
      studentName: data['studentName'] ?? 'N/A',
      isFeesPaid: data['isFeesPaid'] ?? false,
      amount: data['amount'] ?? 0,
      classNo: data['classNo'] ?? 'N/A',
      feeDate: (data['feeDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory FeeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeeModel(
      id: data['studentId'] ?? doc.id,
      studentName: data['studentName'] ?? 'N/A',
      isFeesPaid: data['isFeesPaid'] ?? false,
      amount: data['amount'] ?? 0,
      classNo: data['classNo'] ?? 'N/A',
      feeDate: (data['feeDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
