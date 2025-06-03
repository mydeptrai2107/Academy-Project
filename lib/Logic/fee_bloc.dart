import 'package:ahmed_academy/Data/Repository/fee_repo.dart';
import 'package:ahmed_academy/Models/fee_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ------------------------- EVENTS -------------------------

abstract class FeeEvent {}

class ReadFeeStatus extends FeeEvent {}

class SaveFeeStatus extends FeeEvent {}

class FetchFeeHistory extends FeeEvent {}

class FetchFeeMonths extends FeeEvent {}

// ------------------------- STATES -------------------------

abstract class FeeState {}

class FeeInitial extends FeeState {}

class FeeLoading extends FeeState {}

class SavingFee extends FeeState {}

class FeeSaved extends FeeState {}

class FeeSuccess extends FeeState {
  FeeSuccess({this.feeList, this.months, this.feeHistory});
  Map<String, List<FeeModel>>? feeHistory;
  final List<FeeModel>? feeList;
  final List<String>? months;
}

class FeeError extends FeeState {
  final String errorMessage;
  FeeError(this.errorMessage);
}

// ------------------------- BLOC -------------------------

class FeeBloc extends Bloc<FeeEvent, FeeState> {
  FeeBloc() : super(FeeInitial()) {
    // Fetch current month's fee status
    on<ReadFeeStatus>((event, emit) async {
      try {
        emit(FeeLoading());
        List<FeeModel> feeList = await FeeRepo().fetchFeeStatus();
        emit(FeeSuccess(feeList: feeList));
      } catch (e) {
        print(e);
        emit(FeeError(e.toString()));
      }
    });

    // Save updated fee status
    on<SaveFeeStatus>((event, emit) async {
      final state = this.state;

      if (state is FeeSuccess) {
        try {
          emit(SavingFee());
          // Filter only changed fee models
          List<FeeModel> changedFeeModels =
              state.feeList!.where((fee) => fee.isChanged).toList();

          // Save changed models
          await FeeRepo().saveFeeStatus(changedFeeModels);

          // Reset isChanged flag after saving
          for (var fee in changedFeeModels) {
            fee.isChanged = false;
          }

          emit(FeeSaved());
          await Future.delayed(const Duration(seconds: 1));

          emit(FeeSuccess(
              feeList: state.feeList)); // Re-emit success with updated list
        } catch (e) {
          emit(FeeError(e.toString()));
        }
      }
    });

    // Fetch fee history for a specific month
    on<FetchFeeHistory>((event, emit) async {
      try {
        emit(FeeLoading());
        Map<String, List<FeeModel>> feeHistory =
            await FeeRepo().fetchFeeHistory();
        List<String> months = feeHistory.keys.toList();

        emit(FeeSuccess(feeHistory: feeHistory, months: months));
      } catch (e) {
        print("Error fetching fee history: $e");
        emit(FeeError(e.toString()));
      }
    });
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print("Bloc Error: $error");
  }

  // @override
  // void onChange(Change<FeeState> change) {
  //   super.onChange(change);
  //   print("State Changed: $change");
  // }
}
