import 'package:ahmed_academy/Logic/fee_bloc.dart';
import 'package:ahmed_academy/Models/fee_model.dart';
import 'package:ahmed_academy/Settings/Widget/container_with_lead.dart';
import 'package:ahmed_academy/Settings/Widget/custom_popup.dart';
import 'package:ahmed_academy/Settings/Widget/error_widget.dart';
import 'package:ahmed_academy/Settings/config/push_navigation.dart';
import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeeStatus extends StatefulWidget {
  const FeeStatus({super.key});

  @override
  State<FeeStatus> createState() => _FeeStatusState();
}

class _FeeStatusState extends State<FeeStatus> {
  String selectedClass = "All";
  final List<String> classOptions = [
    "All",
    "Class 9",
    "Class 10",
    "Class 11",
    "Class 12"
  ];

  // Use ValueNotifier for isEditMode
  final ValueNotifier<bool> isEditModeNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    isEditModeNotifier.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FeeBloc()..add(ReadFeeStatus()), // Provide a single instance
      child: Scaffold(
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: isEditModeNotifier,
          builder: (context, isEditMode, _) {
            return FloatingActionButton(
              backgroundColor: CustomTheme().selectedTextColor,
              foregroundColor: Colors.white,
              child: Icon(
                isEditMode ? Icons.check : Icons.edit_note_rounded,
              ),
              onPressed: () {
                if (isEditMode) {
                  context.read<FeeBloc>().add(SaveFeeStatus());
                }
                isEditModeNotifier.value = !isEditMode;
              },
            );
          },
        ),
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text(
            "Fee Status",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: DropdownButton<String>(
                value: selectedClass,
                dropdownColor: CustomTheme().selectedTextColor,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Mulish',
                ),
                iconEnabledColor: Colors.white,
                iconSize: 24,
                items: classOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedClass = newValue;
                    });
                  }
                },
              ),
            ),
          ],
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
          shadowColor: Colors.black,
          backgroundColor: CustomTheme().selectedTextColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: BlocConsumer<FeeBloc, FeeState>(
          listener: (context, state) async {
            if (state is SavingFee) {
              showDialog(
                context: context,
                builder: (context) =>
                    const CustomPopUp(type: PopUpType.feeStatusLoading),
              );
            } else if (state is FeeSaved) {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) =>
                    const CustomPopUp(type: PopUpType.feeStatusSaved),
              );

              await Future.delayed(const Duration(seconds: 1));
              if (!context.mounted) return;
              Navigator.pop(context);
            } else {
              // Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is FeeLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    color: CustomTheme().selectedTextColor,
                  ),
                  const Text(
                    "Fetching Students",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 20),
                  ),
                ],
              );
            } else if (state is FeeError) {
              return const CustomErrorWidget2();
            } else if (state is FeeSuccess) {
              if (state.feeList == null || state.feeList!.isEmpty) {
                return const CustomErrorWidget();
              }

              List<FeeModel> filteredList = selectedClass == "All"
                  ? state.feeList!
                  : state.feeList!
                      .where((fee) => fee.classNo == selectedClass)
                      .toList();

              if (filteredList.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/empty-list.png",
                      color: CustomTheme().selectedTextColor,
                      height: 150,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "It looks like there are no students yet.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mulish',
                          fontSize: 16),
                    ),
                  ],
                ));
              }

              return Column(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isEditModeNotifier,
                    builder: (context, isEditMode, _) {
                      return isEditMode
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Tap on 'Paid' or 'Unpaid' to change the status.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ValueListenableBuilder(
                            valueListenable: isEditModeNotifier,
                            builder: (context, isEditMode, _) {
                              return GestureDetector(
                                onTap: isEditModeNotifier.value
                                    ? () {
                                        setState(() {
                                          filteredList[index].isFeesPaid =
                                              !filteredList[index].isFeesPaid;
                                          filteredList[index].isChanged = true;
                                        });
                                      }
                                    : () {},
                                child: ContainerWithLead(
                                  text: filteredList[index].studentName,
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        filteredList[index].isFeesPaid
                                            ? "Paid"
                                            : "Unpaid",
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontWeight: FontWeight.bold,
                                          color: filteredList[index].isFeesPaid
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      if (filteredList[index].isFeesPaid)
                                        Text(
                                          "on ${formatDate(filteredList[index].feeDate)}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'Mulish',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ],
              );
            } else if (state is SavingFee) {
              return const SizedBox();
            }
            return const Center(child: Text("Unexpected State"));
          },
        ),
      ),
    );
  }
}
