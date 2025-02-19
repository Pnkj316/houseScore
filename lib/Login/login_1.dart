import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Login/login_2.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/app_img.dart';
import 'package:houszscore/Utils/text_style.dart';

class Login1Screen extends StatefulWidget {
  const Login1Screen({super.key});

  @override
  _Login1ScreenState createState() => _Login1ScreenState();
}

class _Login1ScreenState extends State<Login1Screen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().setHeight(900),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImage.bgImg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  children: [
                    _buildNumberOnScreen(
                        1, Alignment.topRight, AppIcon.sixtyTwo),
                    _buildNumberOnScreen(
                        3.5, Alignment.topLeft, AppIcon.fourtyNine),
                    _buildNumberOnScreen(
                        2.5, Alignment.centerRight, AppIcon.seventyOne),
                    _buildNumberOnScreen(
                        1, Alignment.bottomLeft, AppIcon.nintyNine),
                    _buildContainer(),
                  ],
                ),
              ),
            ),
            if (_isLoading) _buildLoadingIndicator(),
          ]),
        ),
      ),
    );
  }

  Widget _buildNumberOnScreen(double height, Alignment aly, String img) {
    return Align(
      heightFactor: height,
      alignment: aly,
      child: Image.asset(
        img,
        scale: 1.1.sp,
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      padding:
          EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 40.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(AppIcon.logo, scale: 5.sp),
              Image.asset(AppIcon.close, scale: 5.sp)
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "Get Started",
            style: TextStyles.size16Weight600.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: 410.w,
            height: 50.h,
            child: Text(
              'Register to personalized property matches based on your preferences',
              style: TextStyles.size14Weight400
                  .copyWith(color: AppColor.grey, fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 300.w,
            height: 60.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: ShapeDecoration(
              color: AppColor.darkGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _handleOnTap,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Create a HouzScore account and more at ',
                            style: TextStyles.size18Weight400.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'SF Pro',
                            ),
                          ),
                          TextSpan(
                            text: 'houzscore.com/more',
                            style: TextStyles.size14Weight400.copyWith(
                              color: AppColor.linkBlue,
                              fontSize: 14.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleOnTap() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login2Screen()),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3.0,
      ),
    );
  }
}
