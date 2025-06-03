import 'package:ahmed_academy/Logic/fee_bloc.dart';
import 'package:ahmed_academy/Presentation/FeeStatus/fee_status_history.dart';
import 'package:ahmed_academy/Settings/Widget/container_with_text.dart';
import 'package:ahmed_academy/Settings/Widget/error_widget.dart';
import 'package:ahmed_academy/Settings/Widget/fetching_students.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeeMonthsPage extends StatelessWidget {
  const FeeMonthsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fee History",
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
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
      body: BlocProvider(
        create: (context) => FeeBloc()..add(FetchFeeHistory()),
        child: Builder(builder: (context) {
          return BlocBuilder<FeeBloc, FeeState>(
            builder: (context, state) {
              if (state is FeeLoading) {
                const FetchingStudents();
              } else if (state is FeeError) {
                return const CustomErrorWidget2();
              } else if (state is FeeSuccess) {
                if (state.months!.isEmpty) {
                  return const CustomErrorWidget();
                } else {
                  return ListView.builder(
                    itemCount: state.months!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            PushNavigation.push(
                                context,
                                FeeStatusHistory(
                                  feeList:
                                      state.feeHistory![state.months![index]]!,
                                  date: state.months![index],
                                ));
                          },
                          child: ContainerWithText(text: state.months![index]));
                    },
                  );
                }
              }
              return const FetchingStudents();
            },
          );
        }),
      ),
    );
  }
}
