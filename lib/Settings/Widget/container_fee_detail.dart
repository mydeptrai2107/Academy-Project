import 'package:ahmed_academy/Models/fee_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeeDetailCard extends StatelessWidget {
  final FeeModel object;

  const FeeDetailCard({
    super.key,
    required this.object,
  });

  String formatDate(DateTime? date) {
    if (date == null) return "Date not provided";
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Name:", object.studentName),
          const SizedBox(height: 6),
          _buildDetailRow("Class:", object.classNo),
          const SizedBox(height: 6),
          _buildDetailRow("Amount:", "Rs. ${object.amount}"),
          const SizedBox(height: 6),
          _buildDetailRow(
            "Fees Paid:",
            object.isFeesPaid ? "Paid" : "Unpaid",
            valueColor: object.isFeesPaid ? Colors.green : Colors.red,
          ),
          if (object.isFeesPaid) ...[
            const SizedBox(height: 6),
            _buildDetailRow(
              "Paid On:",
              formatDate(object.feeDate),
              valueColor: Colors.black87,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'OpenSans',
              fontSize: 15,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
