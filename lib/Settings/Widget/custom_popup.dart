import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum PopUpType {
  attendanceLoading,
  attendanceError,
  attendanceSuccess,
  formError,
  error,
  loading,
  success,

  feeStatusLoading,
  feeStatusSaved,

  quizUploaded,

  updating
}

class CustomPopUp extends StatelessWidget {
  final PopUpType type;
  final String? message;

  const CustomPopUp({super.key, required this.type, this.message});

  @override
  Widget build(BuildContext context) {
    String defaultMessage = "";
    String assetPath = "";
    Widget? customWidget;

    switch (type) {
      case PopUpType.formError:
        defaultMessage = "Please fill out the mandatory fields";
        assetPath = "assets/images/form.png";
        break;
      case PopUpType.error:
        defaultMessage = "Oops! There was an error.";
        assetPath = "assets/images/error.png";
        break;
      case PopUpType.loading:
        defaultMessage = "Please Wait";
        customWidget = SpinKitCircle(color: CustomTheme().selectedTextColor);
        break;
      case PopUpType.success:
        defaultMessage = "Student Added!";
        assetPath = "assets/images/done.png";
        break;
      case PopUpType.attendanceLoading:
        defaultMessage = "Saving Attendance...";
        customWidget = SpinKitCircle(color: CustomTheme().selectedTextColor);
        break;
      case PopUpType.attendanceError:
        defaultMessage = "Oops! There was an error.";
        assetPath = "assets/images/error.png";
        break;
      case PopUpType.attendanceSuccess:
        defaultMessage = "Attendance Saved!";
        assetPath = "assets/images/attendance-saved.png";
        break;

      case PopUpType.feeStatusLoading:
        defaultMessage = "Updating Fee Status";
        customWidget = SpinKitCircle(color: CustomTheme().selectedTextColor);

      case PopUpType.feeStatusSaved:
        defaultMessage = "Saved!";
        assetPath = "assets/images/done.png";

      case PopUpType.quizUploaded:
        defaultMessage = "Quiz Uploaded!";
        assetPath = "assets/images/done.png";

      case PopUpType.updating:
        defaultMessage = "Updating";
        customWidget = SpinKitCircle(color: CustomTheme().selectedTextColor);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 200,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(177),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (customWidget != null)
                customWidget
              else
                Image.asset(assetPath, height: 80),
              const SizedBox(height: 10),
              Text(
                message ?? defaultMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
