import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';

class StarScore extends StatefulWidget {
  final int height;
  final int fontSize;
  final String propertyId;
  final String userId;

  const StarScore({
    super.key,
    required this.height,
    required this.fontSize,
    required this.propertyId,
    required this.userId,
  });

  @override
  _StarScoreState createState() => _StarScoreState();
}

class _StarScoreState extends State<StarScore> {
  bool hasVisitedData = false;
  double score = 0.0;

  @override
  void initState() {
    super.initState();
    checkVisitedData();
  }

  Future<void> fetchPropertyRating() async {
    try {
      FirebaseService firebaseService = FirebaseService();
      double fetchedScore =
          await firebaseService.getPropertyScore(widget.propertyId);

      setState(() {
        if (fetchedScore > 0) {
          hasVisitedData = true;
          score = fetchedScore;
        } else {
          hasVisitedData = false;
        }
      });
    } catch (e) {
      print("Error fetching property rating: $e");
      setState(() {
        hasVisitedData = false;
      });
    }
  }

  Future<void> checkVisitedData() async {
    bool exists = await FirebaseService().isPropertyVisited(widget.propertyId);
    setState(() {
      hasVisitedData = exists;
    });

    if (exists) {
      fetchPropertyRating();
    }
  }

  @override
  Widget build(BuildContext context) {
    return hasVisitedData
        ? Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcon.scoreGreen,
                    width: widget.height.w,
                    height: widget.height.h,
                  ),
                  Text(
                    score.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.fontSize.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5.w),
            ],
          )
        : SizedBox.shrink();
  }
}
