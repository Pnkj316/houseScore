import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Components/custom_appbar.dart';
import 'package:houszscore/Login/login_3.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class Login2Screen extends StatefulWidget {
  const Login2Screen({super.key});

  @override
  State<Login2Screen> createState() => _Login2ScreenState();
}

class _Login2ScreenState extends State<Login2Screen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImageContainer(AppIcon.houseIcon),
              SizedBox(height: 24.h),
              _buildTextBox("What would you like to do today?"),
              SizedBox(height: 24.h),
              _buildActionButton(context)
            ],
          ),
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 3.0,
            ),
          ),
      ]),
    );
  }

  Widget _buildImageContainer(String img) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: ShapeDecoration(
        shape: const OvalBorder(),
        color: AppColor.lightBlue,
      ),
      child: Image.asset(
        img,
        scale: 5.sp,
      ),
    );
  }

  Widget _buildTextBox(String txt) {
    return SizedBox(
      width: 342.w,
      child: Text(
        txt,
        textAlign: TextAlign.center,
        style: TextStyles.size32Weight600.copyWith(
          color: AppColor.darkGrey,
          fontFamily: 'SF Pro',
          fontSize: 32.sp,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Column(
      children: [
        ButtonWidget(
          txtColor: Colors.white,
          color: Colors.black,
          height: 50.h,
          width: double.infinity,
          label: "Create a HouzScore Account",
          onTap: () {
            setState(() {
              _isLoading = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login3Screen()),
            );
            setState(() {
              _isLoading = false;
            });
          },
        ),
        SizedBox(height: 10.h),
        ButtonWidget(
          txtColor: Colors.black,
          color: AppColor.btnGrey,
          height: 50.h,
          width: double.infinity,
          label: "Manage Account",
          onTap: () {},
        ),
      ],
    );
  }
}
