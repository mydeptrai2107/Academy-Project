import 'package:ahmed_academy/Models/fee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FeeProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getFormattedMonth(DateTime date) =>
      DateFormat('MMM-yyyy').format(date);

  Future<bool> checkAndCopyLatestAvailableData() async {
    DateTime now = DateTime.now();
    String currentMonth = _getFormattedMonth(now);

    try {
      final snapshot = await _firestore.collection("FeeStatus").get();
      List<String> allMonths = snapshot.docs
          .map((doc) => doc.id)
          .where((id) => id.compareTo(currentMonth) < 0)
          .toList()
        ..sort((a, b) => b.compareTo(a));

      if (allMonths.isEmpty) {
        print("No previous data found.");
        return false;
      }

      String latestAvailableMonth = allMonths.first;

      final previousSnapshot = await _firestore
          .collection("FeeStatus")
          .doc(latestAvailableMonth)
          .get()
          .timeout(const Duration(seconds: 10));

      if (previousSnapshot.exists) {
        final previousData = previousSnapshot.data() as Map<String, dynamic>;
        print("Found data from: $latestAvailableMonth");

        final updatedData = previousData.map((key, value) {
          value['isFeesPaid'] = false;
          value['feeDate'] = Timestamp.fromDate(now); // ✅ Add new feeDate
          return MapEntry(key, value);
        });

        await _firestore
            .collection("FeeStatus")
            .doc(currentMonth)
            .set(updatedData, SetOptions(merge: true));

        return true;
      } else {
        print("Latest data doc exists but has no data.");
        return false;
      }
    } catch (e) {
      print("Error checking previous data: $e");
      throw Exception("$e");
    }
  }

  Future<List<FeeModel>> fetchFeeStatus() async {
    try {
      String currentMonth = _getFormattedMonth(DateTime.now());

      var snapshot = await _firestore
          .collection("FeeStatus")
          .doc(currentMonth)
          .get()
          .timeout(const Duration(seconds: 10));

      if (!snapshot.exists) {
        bool created = await checkAndCopyLatestAvailableData();
        if (!created)
          return [];
        else {
          snapshot = await _firestore
              .collection("FeeStatus")
              .doc(currentMonth)
              .get()
              .timeout(const Duration(seconds: 10));
        }
      }

      final data = snapshot.data() as Map<String, dynamic>;
      return data.entries.map((entry) {
        final student = entry.value as Map<String, dynamic>;
        return FeeModel(
          id: entry.key,
          studentName: student['studentName'] ?? 'N/A',
          classNo: student['classNo'] ?? 'N/A',
          isFeesPaid: student['isFeesPaid'] ?? false,
          amount: student['amount'] ?? 0,
          feeDate: (student['feeDate'] as Timestamp?)?.toDate() ??
              DateTime.now(), // ✅ Handle date
        );
      }).toList();
    } catch (e) {
      print("Error fetching fee status: $e");
      throw Exception("$e");
    }
  }

  Future<void> saveFeeStatus(List<FeeModel> feeStatusList) async {
    try {
      String currentMonth = _getFormattedMonth(DateTime.now());
      DocumentReference feeRef =
          FirebaseFirestore.instance.collection('FeeStatus').doc(currentMonth);

      Map<String, dynamic> feeData = {
        for (var feeModel in feeStatusList) feeModel.id: feeModel.toMap(),
      };

      await feeRef.set(feeData, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Error saving fee status: $e");
    }
  }

  Future<Map<String, List<FeeModel>>> fetchFeeHistory() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("FeeStatus")
          .get()
          .timeout(const Duration(seconds: 10));

      if (snapshot.docs.isEmpty) {
        return {};
      }

      return {
        for (var doc in snapshot.docs)
          doc.id: (doc.data())
              .entries
              .map((entry) => FeeModel.fromFirebaseMap(entry.key, entry.value))
              .toList()
      };
    } catch (e) {
      throw Exception("Error fetching fee history with months: $e");
    }
  }
}
