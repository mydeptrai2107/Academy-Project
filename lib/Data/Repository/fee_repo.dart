import 'package:ahmed_academy/Data/Data%20Providers/fee_provider.dart';
import 'package:ahmed_academy/Models/fee_model.dart';

class FeeRepo {
  final FeeProvider feeProvider = FeeProvider();

  Future<List<FeeModel>> fetchFeeStatus() async {
    try {
      print("---- Sending Request ----");
      final feeList = await feeProvider.fetchFeeStatus();
      print("Response: $feeList");
      print("\n---- Request Ended ----");
      return feeList;
    } catch (e) {
      print("Error: $e");
      throw Exception("$e");
    }
  }

  Future<void> saveFeeStatus(List<FeeModel> feeStatusList) async {
    try {
      print("---- Sending Request ----");
      await feeProvider.saveFeeStatus(feeStatusList);
      print("\n---- Request Ended ----");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Map<String, List<FeeModel>>> fetchFeeHistory() async {
    try {
      print("---- Sending Request for Fee History ----");
      final feeList = await feeProvider.fetchFeeHistory();
      print("Response: $feeList");
      print("\n---- Request Ended ----");
      return feeList;
    } catch (e) {
      print("Error fetching fee history: $e");
      throw Exception("$e");
    }
  }
}
