import 'package:flutter/material.dart';
import 'package:houszscore/Utils/text_style.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.label,
      required this.onTap,
      required this.color,
      required this.txtColor,
      this.isLoading = false,
      this.isDisabled = false});
  final double height;
  final double width;
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final Color txtColor;
  final bool isLoading;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                )
              : Text(
                  label,
                  style: TextStyles.size16Weight600.copyWith(color: txtColor),
                ),
        ),
      ),
    );
  }
}
