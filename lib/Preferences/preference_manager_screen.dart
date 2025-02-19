import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/BottomNavBar/bottom_navbar.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_img.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:houszscore/modal/initialize_screen_data.dart';
import 'package:houszscore/modal/preference%20screen%20component/add_criteria_dialogue.dart';
import 'package:houszscore/modal/preference%20screen%20component/optionselcted.dart';
import 'package:houszscore/modal/screen_data.dart';

class PreferenceManager extends StatefulWidget {
  final String userId;
  final String? initialText2;
  final String? initialPreferenceValue;
  final int? screenDataList;
  final bool isUpdate;

  const PreferenceManager({
    super.key,
    required this.userId,
    this.initialText2,
    this.initialPreferenceValue,
    required this.isUpdate,
    this.screenDataList,
  });

  @override
  _PreferenceManagerState createState() => _PreferenceManagerState();
}

class _PreferenceManagerState extends State<PreferenceManager> {
  int? selectedOption;
  int? selectedImportance;
  bool isButtonEnabled = false;
  late double _sliderValue;

  bool _isLoading = false;
  Map<String, dynamic> selectedOptionsMap = {};
  String? selectedPreference;

  int currentIndex = 0;
  late List<ScreenData> screens;

  @override
  void initState() {
    super.initState();
    screens = ScreenDataInitializer.initializeScreens();
    _setInitialScreenIndex();

    double min = screens[currentIndex].minValue ?? 0.0;
    double max = screens[currentIndex].maxValue ?? 100.0;
    _sliderValue = ((min + max) / 2).clamp(min, max);
  }

  void _onFinish() async {
    _saveOption();
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseService().savePreference(selectedOptionsMap);
      nextScreen();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving preferences: ${e.toString()}")),
      );
    }
  }

  void _onNext() {
    bool canProceed = screens[currentIndex].optionType == OptionType.slider
        ? _sliderValue > (screens[currentIndex].minValue ?? 0.0)
        : selectedOptionsMap.containsKey(screens[currentIndex].screenKey);

    if (canProceed) {
      _saveOption();
      nextScreen();
      setState(() {
        selectedOption = null;
        selectedImportance = null;
      });
    } else {
      print("Can't proceed yet.");
    }
  }

  void _onSliderChanged(double newValue) {
    setState(() {
      _sliderValue = newValue;
    });
    print("Slider Value: $_sliderValue");
    _saveOption();
  }

  void _onOptionSelected(int selectedValue) {
    setState(() {
      selectedImportance = selectedValue;
      selectedPreference = screens[currentIndex].options?.keys.firstWhere(
            (key) => screens[currentIndex].options![key] == selectedValue,
          );
    });

    print("Option selected: $selectedPreference - Value: $selectedImportance");

    _saveOption();
  }

  void _showAddCriteriaDialog() {
    _saveOption();

    TextEditingController criteriaController = TextEditingController();

    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return AddCriteriaDialog(
          criteriaController: criteriaController,
          onCustomCriteriaAdded: _addCustomCriteria,
        );
      },
    );
  }

  void _setInitialScreenIndex() {
    for (int i = 0; i < screens.length; i++) {
      if (screens[i].text2 == widget.initialText2) {
        setState(() {
          currentIndex = i;
        });
        break;
      }
    }
  }

  void _addCustomCriteria(String customText) {
    setState(() {
      final newScreen = ScreenData(
        screenKey: "${customText}",
        optionType: OptionType.segment,
        text: "How important is the ${customText} for you?",
        text2: "CUSTOM_${screens.length}",
        imageUrl: AppImage.whiteWall,
        options: {
          "Not Important": 1,
          "Slightly Important": 2,
          "Moderately Important": 3,
          "Very Important": 4,
          "Extremely Important": 5
        },
      );
      screens.add(newScreen);

      currentIndex = screens.length - 1;
    });
  }

  void _saveOption() {
    if (currentIndex < 0 || currentIndex >= screens.length) {
      print("Error: Invalid screen index $currentIndex");
      return;
    }

    final currentScreen = screens[currentIndex];
    dynamic selectedValue = currentScreen.optionType == OptionType.slider
        ? _sliderValue
        : selectedImportance;

    if (selectedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an option to proceed.")),
      );
      return;
    }

    setState(() {
      selectedOptionsMap[currentScreen.screenKey] = selectedValue;
    });

    FirebaseService().updatePreference(
      currentScreen.screenKey,
      selectedValue,
    );
  }

  void nextScreen() {
    if (currentIndex < screens.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      FirebaseService().updateAllPreferences(selectedOptionsMap);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavbar()),
        (route) => false,
      );
      print("Preference Completed");
    }
  }

  void _onUpdate() async {
    _saveOption();
    setState(() {
      _isLoading = true;
    });

    try {
      for (var entry in selectedOptionsMap.entries) {
        await FirebaseService().updatePreference(
          entry.key,
          entry.value,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences updated successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update preferences: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${currentIndex + 1} of ${widget.screenDataList ?? screens.length}",
          style: TextStyle(color: AppColor.darkGrey, fontSize: 18),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            setState(() {
              selectedOptionsMap.clear();
            });
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          widget.isUpdate
              ? TextButton(
                  onPressed: _onUpdate,
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      color: AppColor.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeading(screens[currentIndex].text),
                    SizedBox(height: 16.h),
                    _buildTxtImg(
                      screens[currentIndex].text2,
                      screens[currentIndex].imageUrl,
                    ),
                    SizedBox(height: 30.h),
                    OptionSelectionWidget(
                      sliderValue: _sliderValue,
                      optionType: screens[currentIndex].optionType,
                      options: screens[currentIndex].options,
                      minValue: screens[currentIndex].minValue ?? 0,
                      maxValue: screens[currentIndex].maxValue ?? 100,
                      selectedOption: selectedOption,
                      selectedImportance: selectedImportance,
                      onOptionSelected: _onOptionSelected,
                      onSliderChanged: _onSliderChanged,
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    bool isLastScreen = currentIndex == screens.length - 1;
    bool canProceed = screens[currentIndex].optionType == OptionType.slider
        ? _sliderValue > (screens[currentIndex].minValue ?? 0.0)
        : selectedOptionsMap.containsKey(screens[currentIndex].screenKey);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(
          "Skip",
          () {
            setState(() {
              selectedOption = null;
              selectedImportance = null;
            });
          },
          AppColor.darkGrey,
          const Color.fromARGB(255, 235, 235, 235),
          90.w,
        ),
        if (isLastScreen)
          _buildButton(
            "Add Criteria",
            _showAddCriteriaDialog,
            AppColor.darkGrey,
            const Color.fromARGB(255, 247, 247, 247),
            110.w,
          ),
        _buildButton(
          isLastScreen ? "Finish" : "Next",
          canProceed
              ? () {
                  if (isLastScreen) {
                    _onFinish();
                  } else {
                    _onNext();
                  }
                }
              : null,
          Colors.white,
          canProceed
              ? (isLastScreen ? AppColor.blue : AppColor.darkGrey)
              : Colors.grey,
          90.w,
          isDisabled: !canProceed,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildButton(
    String label,
    VoidCallback? onTap,
    Color txtColor,
    Color color,
    double width, {
    bool isDisabled = false,
    bool isLoading = false,
  }) {
    return ButtonWidget(
      height: 45.h,
      width: width,
      label: label,
      onTap: isDisabled ? null : onTap,
      color: color,
      txtColor: txtColor,
      isDisabled: isDisabled,
      isLoading: isLoading,
    );
  }

  Widget _buildHeading(String heading) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        heading,
        style: TextStyles.size22Weight600.copyWith(
          color: AppColor.darkGrey,
          fontSize: 22.sp,
        ),
      ),
    );
  }

  Widget _buildTxtImg(String txt, String img) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txt,
          style: TextStyles.size14Weight600.copyWith(
            color: AppColor.grey,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: Image.asset(
            img,
            fit: BoxFit.cover,
            height: 200.h,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
