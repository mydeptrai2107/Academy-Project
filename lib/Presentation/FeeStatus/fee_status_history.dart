import 'package:ahmed_academy/Models/fee_model.dart';
import 'package:ahmed_academy/Settings/Widget/container_fee_detail.dart';
import 'package:ahmed_academy/Settings/Widget/error_widget.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';

class FeeStatusHistory extends StatelessWidget {
  const FeeStatusHistory({
    required this.date,
    required this.feeList,
    super.key,
  });

  final String date;
  final List<FeeModel> feeList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Fee History",
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
            Text(
              date,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Mulish', fontSize: 14),
            )
          ],
        ),
        leading: InkWell(
          onTap: () {
            PushNavigation.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        titleSpacing: 0,
        elevation: 2,
        toolbarHeight: 80,
        shadowColor: Colors.black,
        backgroundColor: CustomTheme().selectedTextColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: feeList.isEmpty
          ? const CustomErrorWidget(
              text: "Fee not marked for this month.",
            )
          : ListView.builder(
              itemCount: feeList.length,
              itemBuilder: (BuildContext context, int index) {
                return FeeDetailCard(object: feeList[index]);
              },
            ),
    );
  }
}
