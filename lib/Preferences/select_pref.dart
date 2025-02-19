import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_img.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/Preferences/preference_manager_screen.dart';

class SelectPreferencesScreen extends StatefulWidget {
  @override
  _SelectPreferencesScreenState createState() =>
      _SelectPreferencesScreenState();
}

class _SelectPreferencesScreenState extends State<SelectPreferencesScreen> {
  String? selectedOption;

  final List<Map<String, String>> houseType = [
    {'label': 'House', 'image': AppImage.house},
    {'label': 'Townhouse', 'image': AppImage.townhouse},
    {'label': 'Condo', 'image': AppImage.condo},
    {'label': 'Land', 'image': AppImage.land},
    {'label': 'Multi-family', 'image': AppImage.multi},
    {'label': 'Mobile', 'image': AppImage.mob},
  ];

  void _onOptionSelected(String label) {
    setState(() {
      selectedOption = label;
    });
  }

  void _navigateToNextScreen() {
    if (selectedOption != null) {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user?.uid ?? '';
      Widget nextScreen = PreferenceManager(
        isUpdate: false,
        userId: userId,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => nextScreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your preferences',
              style: TextStyles.size22Weight600
                  .copyWith(color: AppColor.darkGrey, fontSize: 22.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Welcome, let\'s get started with a few questions to understand your preferences.',
              style: TextStyles.size14Weight400
                  .copyWith(color: AppColor.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1.3,
                ),
                itemCount: houseType.length,
                itemBuilder: (context, index) {
                  final option = houseType[index];
                  final isSelected = selectedOption == option['label'];
                  return GestureDetector(
                    onTap: () => _onOptionSelected(option['label']!),
                    child: Container(
                      padding: EdgeInsets.all(7.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color:
                              isSelected ? Colors.blue : Colors.grey.shade300,
                          width: 2.w,
                        ),
                        color: isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            option['image']!,
                            scale: 3,
                            height: 65.h,
                            width: 70.w,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            option['label']!,
                            style: TextStyles.size16Weight600.copyWith(
                              color: isSelected ? Colors.blue : Colors.black87,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.bottomRight,
              child: ButtonWidget(
                height: 50.h,
                width: 85.w,
                label: "Next",
                onTap: selectedOption != null ? _navigateToNextScreen : () {},
                color: AppColor.darkGrey,
                txtColor: Colors.white,
                isDisabled: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
