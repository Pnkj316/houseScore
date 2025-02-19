import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Components/custom_appbar.dart';
import 'package:houszscore/Login/Auth/auth.dart';
import 'package:houszscore/Login/login_6.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class Login5Screen extends StatefulWidget {
  final String email;
  const Login5Screen({super.key, required this.email});

  @override
  _Login5ScreenState createState() => _Login5ScreenState();
}

class _Login5ScreenState extends State<Login5Screen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordValid = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final String password = _passwordController.text;
    setState(() {
      _isPasswordValid = password.length >= 8;
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
                "Set Password",
                "Please enter a password 8 characters minimum",
              ),
              SizedBox(height: 24.h),
              _buildTextField(),
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
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.black)),
        hintText: "Password",
        hintStyle: TextStyles.size18Weight500.copyWith(
          color: AppColor.grey,
          fontFamily: 'SF Pro',
          fontSize: 18.sp,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 175, 175, 175),
          ),
        ),
        suffixIcon: IconButton(
          icon: Text(
            _obscurePassword ? "Show" : "Hide",
            style: TextStyles.size14Weight400.copyWith(
              fontFamily: 'SF Pro',
              color: AppColor.grey,
              fontSize: 14.sp,
            ),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ButtonWidget(
      txtColor: _isPasswordValid ? Colors.white : AppColor.grey,
      color: _isPasswordValid ? Colors.black : AppColor.btnGrey,
      height: 50.h,
      width: double.infinity,
      label: "Next",
      isLoading: _isLoading,
      onTap: _isPasswordValid
          ? () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Auth().createUserWithEmailAndPassword(
                  email: widget.email,
                  password: _passwordController.text,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login6Screen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
              setState(() {
                _isLoading = false;
              });
            }
          : () {},
    );
  }
}
