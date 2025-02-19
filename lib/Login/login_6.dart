import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Components/custom_appbar.dart';
import 'package:houszscore/Login/login7.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class Login6Screen extends StatefulWidget {
  const Login6Screen({Key? key}) : super(key: key);

  @override
  _Login6ScreenState createState() => _Login6ScreenState();
}

class _Login6ScreenState extends State<Login6Screen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    final String name = _nameController.text;
    setState(() {
      _isNameValid = name.isNotEmpty && name.length > 2;
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
              _buildImageContainer(AppIcon.camera),
              SizedBox(height: 24.h),
              _buildTextBox("Your Profile", "Please tell us your name"),
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
      controller: _nameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.black)),
        hintText: "Name",
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
      ),
    );
  }

  Widget _buildActionButton() {
    return ButtonWidget(
      txtColor: _isNameValid ? Colors.white : AppColor.grey,
      color: _isNameValid ? Colors.black : AppColor.btnGrey,
      height: 50.h,
      width: double.infinity,
      label: "Next",
      isLoading: _isLoading,
      onTap: _isNameValid
          ? () {
              setState(() {
                _isLoading = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Login7Screen(name: _nameController.text)),
              );
              setState(() {
                _isLoading = false;
              });
            }
          : () {},
    );
  }
}
