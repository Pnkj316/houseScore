import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Components/custom_appbar.dart';
import 'package:houszscore/Preferences/select_pref.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Login7Screen extends StatefulWidget {
  const Login7Screen({super.key, required this.name});
  final String name;

  @override
  _Login7ScreenState createState() => _Login7ScreenState();
}

class _Login7ScreenState extends State<Login7Screen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameValid = false;
  bool _isLoading = false;
  final int _wordLimit = 100;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateName);

    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    if (!mounted) return;
    final String name = _nameController.text;
    final int wordCount = name.trim().split(RegExp(r'\s+')).length;
    setState(() {
      _isNameValid = wordCount > 0 && wordCount <= _wordLimit;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final String? option = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'camera'),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'gallery'),
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (option != null) {
      XFile? image;
      if (option == 'camera') {
        image = await _picker.pickImage(source: ImageSource.camera);
      } else if (option == 'gallery') {
        image = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (image != null) {
        setState(() {
          _profileImage = File(image!.path);
        });
      }
    }
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
              GestureDetector(
                onTap: _pickImage,
                child: _profileImage == null
                    ? Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.lightGrey,
                        ),
                        child: Icon(Icons.camera_alt, color: AppColor.grey),
                      )
                    : ClipOval(
                        child: Image.file(
                          _profileImage!,
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(height: 24.h),
              _buildTextBox(
                "Your Profile",
                "Introduce yourself to others in your properties",
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
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGrey),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Text(
              widget.name,
              textAlign: TextAlign.left,
              style: TextStyles.size16Weight500.copyWith(
                color: AppColor.darkGrey,
                fontFamily: 'SF Pro',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      maxLines: null,
      minLines: 1,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.black)),
        hintText: "About Yourself (Max $_wordLimit words)",
        hintStyle: TextStyles.size16Weight400.copyWith(
          color: AppColor.grey,
          fontFamily: 'SF Pro',
          fontSize: 16.sp,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          borderSide: BorderSide(
            color: AppColor.lightGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ButtonWidget(
      txtColor: _isNameValid ? Colors.white : AppColor.grey,
      color: _isNameValid && _profileImage != null
          ? Colors.black
          : AppColor.btnGrey,
      height: 50.h,
      width: double.infinity,
      label: "Next",
      isLoading: _isLoading,
      onTap: _isNameValid && _profileImage != null
          ? () async {
              setState(() {
                _isLoading = true;
              });
              await _saveUserProfile();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectPreferencesScreen()),
                (Route<dynamic> route) => false,
              ).then((_) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              });
              ;
            }
          : () {},
    );
  }

  Future<void> _saveUserProfile() async {
    try {
      String? imageUrl;
      if (_profileImage != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${widget.name}.jpg');
        final UploadTask uploadTask = storageRef.putFile(_profileImage!);
        final TaskSnapshot downloadUrl = await uploadTask;
        imageUrl = await downloadUrl.ref.getDownloadURL();
      }
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in.");
        return;
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': widget.name,
        'description': _nameController.text,
        'imageUrl': imageUrl,
      });

      print("User profile saved successfully.");
    } catch (e) {
      print("Failed to save user profile: $e");
    }
  }
}
