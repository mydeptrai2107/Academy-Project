import 'package:flutter/material.dart';

class QuizContainer extends StatelessWidget {
  final String studentName;
  final int? initialMarks;
  final Function(String) onMarksChanged;

  const QuizContainer({
    super.key,
    required this.studentName,
    required this.onMarksChanged,
    this.initialMarks,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController marksController =
        TextEditingController(text: initialMarks?.toString() ?? '');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2.5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 4.0,
        //     offset: const Offset(1, 2),
        //   ),
        // ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              studentName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Mulish',
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: TextField(
              controller: marksController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                color: Colors.grey[800],
              ),
              decoration: InputDecoration(
                labelText: 'Marks',
                labelStyle: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                fillColor: Colors.grey[100],
                filled: true,
              ),
              onChanged: onMarksChanged,
            ),
          ),
        ],
      ),
    );
  }
}
