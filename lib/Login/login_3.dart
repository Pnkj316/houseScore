import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Components/custom_appbar.dart';
import 'package:houszscore/Login/login_4.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class Login3Screen extends StatefulWidget {
  const Login3Screen({Key? key}) : super(key: key);

  @override
  _Login3ScreenState createState() => _Login3ScreenState();
}

class _Login3ScreenState extends State<Login3Screen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final String email = _emailController.text.trim();
    final bool isValid =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
            .hasMatch(email);
    setState(() {
      _isEmailValid = isValid;
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
              _buildImageContainer(AppIcon.mailIcon),
              SizedBox(height: 24.h),
              _buildTextBox(
                  "Continue with Email", "Sign in or sign up with your email."),
              SizedBox(height: 24.h),
              _buildTextField(),
              SizedBox(height: 24.h),
              _buildActionButton()
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

  Widget _buildTextBox(String txt1, String txt2) {
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
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.black)),
        hintText: "Email Address",
        hintStyle: TextStyles.size18Weight500.copyWith(
          color: AppColor.grey,
          fontFamily: 'SF Pro',
          fontSize: 18.sp,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 175, 175, 175),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ButtonWidget(
      txtColor: _isEmailValid ? Colors.white : AppColor.grey,
      color: _isEmailValid ? Colors.black : AppColor.btnGrey,
      height: 50.h,
      width: double.infinity,
      isLoading: _isLoading,
      label: "Next",
      onTap: () {
        if (_isEmailValid) {
          setState(() {
            _isLoading = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login4Screen(email: _emailController.text),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a valid email address'),
            ),
          );
        }
      },
    );
  }
}
