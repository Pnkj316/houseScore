import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:houszscore/BottomNavBar/bottom_navbar.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Login/login_3.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordValid = false, _isEmailValid = false, _obscurePassword = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      _isEmailValid =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
              .hasMatch(email);
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _isPasswordValid = password.length >= 8;
    });
  }

  Future<void> _signInWithFirebase() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavbar()),
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      _showError(e);
    }
  }

  void _showError(FirebaseAuthException e) {
    final message = e.code == 'user-not-found'
        ? 'No user found for that email.'
        : e.code == 'wrong-password'
            ? 'Wrong password provided for that user.'
            : 'Password is invalid. Please try again.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.all(30.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 24.h),
                _buildTextBox(
                    "Sign in", "Sign in with your email and password."),
                SizedBox(height: 24.h),
                _buildTextField(_emailController, "Email Address"),
                SizedBox(height: 16.h),
                _buildPasswordTextField(),
                SizedBox(height: 30.h),
                _buildActionButton(),
              ],
            ),
          ),
        ),
        // if (_isLoading)
        //   Center(
        //     child: CircularProgressIndicator(
        //       valueColor: AlwaysStoppedAnimation<Color>(AppColor.linkBlue),
        //     ),
        //   ),
      ]),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(AppIcon.logo, scale: 7),
      ),
      titleSpacing: 0.5,
      title: Row(
        children: [
          Text("Houz",
              style: TextStyles.size16Weight500
                  .copyWith(color: AppColor.darkGrey)),
          Text("Score",
              style: TextStyles.size16Weight500
                  .copyWith(color: AppColor.linkBlue)),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: InkWell(
              onTap: () {
                setState(() {
                  _isLoading = true;
                });

                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Login3Screen()));

                setState(() {
                  _isLoading = false;
                });
              },
              child: Text("Sign up",
                  style: TextStyles.size14Weight700
                      .copyWith(color: AppColor.darkGrey))),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration:
          ShapeDecoration(shape: const OvalBorder(), color: AppColor.lightBlue),
      child: Image.asset(AppIcon.logo, scale: 5.sp),
    );
  }

  Widget _buildTextBox(String title, String subtitle) {
    return Column(
      children: [
        Text(title,
            style: TextStyles.size32Weight600
                .copyWith(color: AppColor.darkGrey, fontSize: 32.sp)),
        SizedBox(height: 10.h),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: TextStyles.size16Weight400.copyWith(color: AppColor.grey)),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(hint),
      keyboardType: TextInputType.emailAddress,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.black),
      ),
      hintText: hint,
      hintStyle: TextStyles.size18Weight500
          .copyWith(color: AppColor.grey, fontSize: 16.sp),
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: const BorderSide(color: Color.fromARGB(255, 175, 175, 175)),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: _inputDecoration("Password").copyWith(
        suffixIcon: IconButton(
          icon: Text(_obscurePassword ? "Show" : "Hide",
              style: TextStyles.size14Weight400.copyWith(fontSize: 14.sp)),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ButtonWidget(
      txtColor: Colors.white,
      color: Colors.black,
      height: 50.h,
      width: double.infinity,
      label: "Sign In",
      isLoading: _isLoading,
      onTap: () {
        if (_isEmailValid && _isPasswordValid) {
          _signInWithFirebase();
          setState(() {
            _isLoading = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter valid credentials')));
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}
