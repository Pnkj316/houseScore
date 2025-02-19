import 'package:flutter/material.dart';
import 'package:houszscore/Login/Auth/sign_in.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(82 + 1);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(AppIcon.logo, scale: 7),
          ),
          titleSpacing: 0.5,
          title: Row(
            children: [
              Text(
                "Houz",
                style: TextStyles.size16Weight500
                    .copyWith(color: AppColor.darkGrey),
              ),
              Text(
                "Score",
                style: TextStyles.size16Weight500
                    .copyWith(color: AppColor.linkBlue),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(15),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                child: Text(
                  "Sign In",
                  style: TextStyles.size14Weight700
                      .copyWith(color: AppColor.darkGrey),
                ),
              ),
            ),
          ],
        ),
        Divider(
          height: 1,
          thickness: 0.8,
          color: Colors.grey,
        ),
      ],
    );
  }
}
