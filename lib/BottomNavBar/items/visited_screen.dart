import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/BottomNavBar/Provider/userid_provider.dart';
import 'package:houszscore/Components/property_item.dart';
import 'package:houszscore/Components/toggle_button.dart';
import 'package:houszscore/Visit%20Review/visting1_screen.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:houszscore/modal/visting_modal.dart';
import 'package:provider/provider.dart';

class VisitedScreen extends StatefulWidget {
  @override
  State<VisitedScreen> createState() => _VisitedScreenState();
}

class _VisitedScreenState extends State<VisitedScreen> {
  final FirebaseService firebaseService = FirebaseService();
  bool isTileView = false;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).userId;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 244, 248),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtonsWidget(
              isSelected: [!isTileView, isTileView],
              onPressed: (index) {
                setState(() {
                  isTileView = index == 1;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Visited",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('visitingData')
                    .where('userId', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No data available"));
                  }

                  final visites = snapshot.data!.docs;

                  return isTileView
                      ? _buildGridView(visites)
                      : _buildListView(visites);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<QueryDocumentSnapshot> visites) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemCount: visites.length,
      itemBuilder: (context, index) {
        final property = visites[index];
        return StreamBuilder<bool>(
          stream: firebaseService.isFavoriteStream(property.id),
          builder: (context, snapshot) {
            final isFavorite = snapshot.data ?? false;
            return PropertyItem(
              firebaseService: firebaseService,
              image: property['image'] ?? '',
              title: property['name'] ?? 'No Title',
              address: property['address'] ?? 'No Address',
              isFavorite: isFavorite,
              rating: property['propertyRating'] ?? 1,
              isForSale: true,
              isTileView: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Visiting1Screen(
                      userId: property['userId'] ?? '',
                      propertyId: property['propertyId'] ?? '',
                      visitDate: property['visitDate'],
                      rating: property['propertyRating'] ?? 1,
                      address: property['address'] ?? 'No Address',
                      name: property['name'] ?? 'No Title',
                      image: property['image'] ?? '',
                      visitingData: VisitingData.fromJson(
                          property.data() as Map<String, dynamic>),
                      isUpdated: true,
                    ),
                  ),
                );
              },
              onFavoriteToggle: () {
                firebaseService.toggleFavorite(
                  property.id,
                  property.data() as Map<String, dynamic>,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> visites) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: visites.length,
      itemBuilder: (context, index) {
        final property = visites[index];
        return StreamBuilder<bool>(
          stream: firebaseService.isFavoriteStream(property.id),
          builder: (context, snapshot) {
            final isFavorite = snapshot.data ?? false;
            return PropertyItem(
              firebaseService: firebaseService,
              image: property['image'] ?? '',
              title: property['name'] ?? 'No Title',
              address: property['address'] ?? 'No Address',
              isFavorite: isFavorite,
              isForSale: true,
              isTileView: true,
              rating: property['propertyRating'] ?? 1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Visiting1Screen(
                      userId: property['userId'] ?? '',
                      propertyId: property['propertyId'] ?? '',
                      visitDate: property['visitDate'],
                      rating: property['propertyRating'] ?? 1,
                      address: property['address'] ?? 'No Address',
                      name: property['name'] ?? 'No Title',
                      image: property['image'] ?? '',
                      visitingData: VisitingData.fromJson(
                          property.data() as Map<String, dynamic>),
                      isUpdated: true,
                    ),
                  ),
                );
              },
              onFavoriteToggle: () {
                firebaseService.toggleFavorite(
                  property.id,
                  property.data() as Map<String, dynamic>,
                );
              },
            );
          },
        );
      },
    );
  }
}
