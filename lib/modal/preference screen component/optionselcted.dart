import 'package:flutter/material.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/modal/screen_data.dart';

class OptionSelectionWidget extends StatelessWidget {
  final OptionType optionType;
  final Map<String, int>? options;
  final double minValue;
  final double maxValue;
  final double sliderValue;
  final int? selectedOption;
  final int? selectedImportance;
  final Function(int) onOptionSelected;
  final Function(double) onSliderChanged;

  const OptionSelectionWidget({
    Key? key,
    required this.optionType,
    required this.options,
    required this.minValue,
    required this.maxValue,
    required this.selectedOption,
    required this.selectedImportance,
    required this.onOptionSelected,
    required this.onSliderChanged,
    required this.sliderValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (optionType) {
      case OptionType.radio:
        return _buildRadioSelection();
      case OptionType.slider:
        return _buildSliderSelection();
      case OptionType.segment:
        return _buildSegmentSelection();
      default:
        return Container();
    }
  }

  Widget _buildRadioSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options!.entries.map((entry) {
        String label = entry.key;
        int value = entry.value;

        bool isSelected = selectedImportance == value;

        return GestureDetector(
          onTap: () {
            onOptionSelected(value);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.blue : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyles.size20Weight600.copyWith(
                  color: isSelected ? Colors.white : AppColor.darkGrey,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSliderSelection() {
    double currentSliderValue = sliderValue;
    ;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '\$${currentSliderValue.toInt()}',
          style: TextStyles.size20Weight600.copyWith(
            color: AppColor.darkGrey,
          ),
        ),
        SizedBox(height: 10),
        Slider(
          value: currentSliderValue.clamp(minValue, maxValue),
          min: minValue,
          max: maxValue,
          activeColor: AppColor.blue,
          inactiveColor: Colors.grey.shade300,
          thumbColor: Colors.white,
          onChanged: onSliderChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("\$${minValue.toInt()}", style: TextStyles.size14Weight500),
            Text("\$${maxValue.toInt()}", style: TextStyles.size14Weight500),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentSelection() {
    return Container(
      height: 250.0,
      child: ListView.builder(
        itemCount: options!.length,
        itemBuilder: (context, index) {
          String label = options!.keys.elementAt(index);
          int value = options!.values.elementAt(index);

          bool isSelected = selectedImportance == value;

          return GestureDetector(
            onTap: () {
              onOptionSelected(value);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      isSelected ? AppIcon.blue_tick : AppIcon.grey_circle,
                      width: 22,
                      height: 22,
                    ),
                    SizedBox(width: 15),
                    Text(label,
                        style: TextStyles.size16Weight400
                            .copyWith(color: AppColor.darkGrey)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
