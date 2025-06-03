import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectsCubit extends Cubit<Map<String, bool>> {
  SubjectsCubit()
      : super({
          "Maths": false,
          "Physics": false,
          "Chemistry": false,
          "Computer": false,
          "Biology": false,
        });

  updateSubject(String subject) {
    final updatedState = Map<String, bool>.from(state);
    updatedState[subject] = !state[subject]!;

    emit(updatedState);
  }

  setSubjects(Map<String, bool> selectedSubjects) {
    final updatedState = {
      "Maths": selectedSubjects["Maths"] ?? false,
      "Physics": selectedSubjects["Physics"] ?? false,
      "Chemistry": selectedSubjects["Chemistry"] ?? false,
      "Computer": selectedSubjects["Computer"] ?? false,
      "Biology": selectedSubjects["Biology"] ?? false,
    };
    emit(updatedState);
  }

  clearSubject() {
    final updatedState = {
      "Maths": false,
      "Physics": false,
      "Chemistry": false,
      "Computer": false,
      "Biology": false,
    };

    emit(updatedState);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}

class FeeCubit extends Cubit<int> {
  FeeCubit(super.initialState);

  calculateFees(Map<String, bool> subjects, int fees) {
    int count = subjects.values.where((selected) => selected).length;
    emit(count * fees);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
