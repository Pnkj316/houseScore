import 'package:flutter/material.dart';
import 'package:houszscore/Utils/app_color.dart';

class RatingOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String section;
  final String userId;
  final bool selected;
  final Function(String, int) onRatingSelected;

  const RatingOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.section,
    required this.userId,
    required this.selected,
    required this.onRatingSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onRatingSelected(section, _getRatingValue(label)),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: selected ? AppColor.blue : Colors.white,
            border: Border.all(color: AppColor.lightGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: selected ? Colors.white : Colors.grey, size: 28),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getRatingValue(String label) {
    switch (label) {
      case "Hate it":
        return 0;
      case "Can live with it":
        return 3;
      case "Love it":
        return 5;
      default:
        return 0;
    }
  }
}
