import 'package:flutter/material.dart';
import 'package:houszscore/BottomNavBar/Provider/userid_provider.dart';
import 'package:houszscore/Login/login_1.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:provider/provider.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/modal/initialize_screen_data.dart';
import 'package:houszscore/payment_method_screen.dart';
import 'package:houszscore/preference_questions.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider?>(context, listen: false);
    final userId = userProvider?.userId ?? 'defaultUserId';

    final _settingsOptions = _getSettingsOptions(context, userId);

    return Scaffold(
      backgroundColor: Color(0xffEEF2F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20),
                child: Text(
                  'Settings',
                  style: TextStyles.size22Weight600.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              _buildSection(context, userId, _settingsOptions.sublist(0, 5)),
              SizedBox(height: 10),
              _buildSection(context, userId, _settingsOptions.sublist(5, 8)),
              SizedBox(height: 10),
              _buildSection(context, userId, _settingsOptions.sublist(8, 9)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Version 24.26 (203886)',
                  style:
                      TextStyles.size14Weight400.copyWith(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String userId, List<Map<String, dynamic>> options) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.shade300, height: 1),
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Image.asset(
                option['icon'] as String,
                scale: 4,
                color: Colors.black,
              ),
            ),
            title: Text(
              option['title'] as String,
              style: TextStyles.size16Weight500,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 25,
            ),
            onTap: () => _handleOnTap(context, option, userId),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getSettingsOptions(
      BuildContext context, String userId) {
    return [
      {
        'icon': AppIcon.prefs,
        'title': 'Preference',
        'onTap': (BuildContext context, String userId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreferenceQuestions(
                userId: userId,
                screenDataList: ScreenDataInitializer.initializeScreens(),
              ),
            ),
          );
        }
      },
      {
        'icon': AppIcon.card,
        'title': 'Payment methods',
        'onTap': (
          BuildContext context,
        ) =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentMethodsScreen(),
              ),
            )
      },
      {'icon': AppIcon.payment, 'title': 'Your payments', 'onTap': null},
      {'icon': AppIcon.noti, 'title': 'Notifications', 'onTap': null},
      {'icon': AppIcon.privacy, 'title': 'Privacy and sharing', 'onTap': null},
      {'icon': AppIcon.term, 'title': 'Terms of Service', 'onTap': null},
      {'icon': AppIcon.term, 'title': 'Privacy Policy', 'onTap': null},
      {'icon': AppIcon.term, 'title': 'Open source licences', 'onTap': null},
      {
        'icon': AppIcon.logout,
        'title': 'Log out',
        'onTap': (BuildContext context, String userId) async {
          await _handleLogout(context);
        },
      },
    ];
  }

  void _handleOnTap(
      BuildContext context, Map<String, dynamic> option, String userId) async {
    final onTapAction = option['onTap'];
    if (onTapAction != null) {
      if (onTapAction is Function) {
        await onTapAction(context, userId);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => onTapAction),
        );
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseService().logout();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context, rootNavigator: true).pop();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Login1Screen()),
          (Route<dynamic> route) => false,
        );
      });
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();

      print("Logout error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to log out. Please try again.")),
      );
    }
  }
}
