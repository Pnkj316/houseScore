import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houszscore/BottomNavBar/items/favorite_screen.dart';
import 'package:houszscore/BottomNavBar/items/setting_screen.dart';
import 'package:houszscore/BottomNavBar/items/suggestion_screen.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/BottomNavBar/items/home_screen.dart';
import 'package:houszscore/BottomNavBar/items/visited_screen.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(onChangeTab: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
      SuggestionScreen(),
      FavoriteScreen(),
      VisitedScreen(),
      SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String?> _fetchProfilePhotoUrl() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No user is logged in.');
      return null;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        print('User document does not exist.');
        return null;
      }

      String? imageUrl = userDoc.data()?['imageUrl'];

      if (imageUrl == null || imageUrl.isEmpty) {
        print('No imageUrl found in Firestore.');
        return null;
      }

      print('Fetched imageUrl: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('Error fetching profile photo: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color.fromARGB(255, 238, 244, 248),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            AppIcon.appLogo,
            height: 40,
            width: 140,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FutureBuilder<String?>(
              future: _fetchProfilePhotoUrl(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null) {
                  return const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  );
                }

                return CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(snapshot.data!),
                  backgroundColor: Colors.grey[200],
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.blue,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(
          color: AppColor.blue,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.black,
        ),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_sharp),
            label: 'Suggestions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: 'Visited',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              height: 24,
              AppIcon.threeDots,
              scale: 3.5,
              color: _selectedIndex == 4 ? AppColor.blue : Colors.black,
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: AppColor.grey),
          suffixIcon: Image.asset(
            AppIcon.settingLogo,
            scale: 4,
          ),
          hintText: 'City, Neighbourhood or Address',
          hintStyle: TextStyles.size14Weight400.copyWith(color: AppColor.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
