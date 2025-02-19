import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Login/login_5.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Components/custom_appbar.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class Login4Screen extends StatefulWidget {
  final String email;

  const Login4Screen({Key? key, required this.email}) : super(key: key);

  @override
  _Login4ScreenState createState() => _Login4ScreenState();
}

class _Login4ScreenState extends State<Login4Screen> {
  TextEditingController _codeController = TextEditingController();
  bool _isCodeValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateCode);
  }

  void _validateCode() {
    final String code = _codeController.text;
    String validCode = "123456";

    setState(() {
      _isCodeValid = code.length == 6 && code == validCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(40.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImageContainer(AppIcon.setPassword),
              SizedBox(height: 24.h),
              _buildTextBox(
                "Enter Code",
                "We sent a verification code to your email",
                widget.email,
              ),
              SizedBox(height: 24.h),
              _buildPinCodeField(),
              SizedBox(height: 24.h),
              _buildActionButton(),
            ],
          ),
        ),
      ),
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

  Widget _buildTextBox(String txt1, String txt2, String mail) {
    return SizedBox(
      width: 342.w,
      child: Column(
        children: [
          Text(
            txt1,
            textAlign: TextAlign.center,
            style: TextStyles.size32Weight600.copyWith(
              color: AppColor.darkGrey,
              fontFamily: 'SF Pro',
              fontSize: 32.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            txt2,
            textAlign: TextAlign.center,
            style: TextStyles.size16Weight400.copyWith(
              color: AppColor.grey,
              fontFamily: 'SF Pro',
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            mail,
            textAlign: TextAlign.center,
            style: TextStyles.size16Weight400.copyWith(
              color: AppColor.darkGrey,
              fontFamily: 'SF Pro',
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinCodeField() {
    return Container(
        padding: EdgeInsets.all(10.w),
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          border: Border.all(color: AppColor.lightGrey),
        ),
        child: PinCodeTextField(
          controller: _codeController,
          appContext: context,
          length: 6,
          onChanged: (value) {},
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            fieldHeight: 25.h,
            fieldWidth: 15.w,
            inactiveColor: Colors.grey,
            activeColor: Colors.grey,
            selectedColor: Colors.black,
            inactiveFillColor: Colors.white,
            activeFillColor: Colors.white,
            selectedFillColor: Colors.white,
            borderWidth: 1.w,
            fieldOuterPadding: EdgeInsets.symmetric(horizontal: 10.w),
          ),
          cursorColor: AppColor.darkGrey,
          keyboardType: TextInputType.number,
        ));
  }

  Widget _buildActionButton() {
    return ButtonWidget(
      txtColor: _isCodeValid ? Colors.white : AppColor.grey,
      color: _isCodeValid ? Colors.black : AppColor.btnGrey,
      height: 50.h,
      width: double.infinity,
      isLoading: _isLoading,
      label: "Next",
      onTap: _isCodeValid
          ? () {
              setState(() {
                _isLoading = true;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login5Screen(email: widget.email),
                ),
              ).then((_) {
                setState(() {
                  _isLoading = false;
                });
              });
            }
          : null,
    );
  }
}
