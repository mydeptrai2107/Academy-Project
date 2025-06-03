import 'package:ahmed_academy/Settings/theme/theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBottomSheet extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final Color backgroundColor;
  final double borderRadius;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  String? selectedValue;
  final TextEditingController controller;

  CustomBottomSheet({
    super.key,
    required this.items,
    required this.controller,
    this.selectedValue,
    this.hintText = "Select Class",
    this.backgroundColor = Colors.white,
    this.borderRadius = 12.0,
    this.shadowColor = Colors.black,
    this.shadowBlurRadius = 8.0,
    this.shadowOffset = const Offset(0, 4),
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.hintText,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return ListTile(
                    tileColor: index.isEven
                        ? CustomTheme().selectedTheme
                        : Colors.white,
                    leading: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index.isOdd
                            ? CustomTheme().selectedTextColor
                            : Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.class_outlined,
                          color: index.isEven
                              ? CustomTheme().selectedTextColor
                              : Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    title: Text(
                      item,
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    onTap: () {
                      setState(() {
                        widget.selectedValue = item;
                        widget.controller.text = item;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selectedValue ?? widget.hintText,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: widget.selectedValue != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontFamily: 'Poppins',
                  color: widget.selectedValue != null
                      ? Colors.black
                      : const Color.fromARGB(255, 104, 104, 104)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      ),
    );
  }
}
