import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/text_style.dart';

class AddCriteriaDialog extends StatelessWidget {
  final TextEditingController criteriaController;
  final Function(String) onCustomCriteriaAdded;

  const AddCriteriaDialog({
    Key? key,
    required this.criteriaController,
    required this.onCustomCriteriaAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Add your own Criteria",
        textAlign: TextAlign.center,
        style: TextStyles.size16Weight700.copyWith(color: Colors.black),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: CupertinoTextField(
          controller: criteriaController,
          placeholder: "Enter criteria",
          maxLines: 1,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyles.size14Weight500.copyWith(color: AppColor.blue),
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            String customText = criteriaController.text.trim();
            if (customText.isNotEmpty) {
              onCustomCriteriaAdded(customText);

              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Criteria cannot be empty!")),
              );
            }
          },
          child: Text(
            "Add",
            style: TextStyles.size14Weight500.copyWith(color: AppColor.blue),
          ),
        ),
      ],
    );
  }
}
