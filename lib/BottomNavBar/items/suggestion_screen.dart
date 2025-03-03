import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houszscore/BottomNavBar/Provider/userid_provider.dart';
import 'package:houszscore/Components/property_item.dart';
import 'package:houszscore/Components/strem_loader.dart';
import 'package:houszscore/Components/toggle_button.dart';
import 'package:houszscore/Components/detail_screen.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:provider/provider.dart';

class SuggestionScreen extends StatefulWidget {
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final FirebaseService firebaseService = FirebaseService();
  bool isTileView = false;

  @override
  Widget build(BuildContext context) {
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
              "Suggestions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('properties')
                    .snapshots(),
                builder: (context, snapshot) {
                  return StreamLoader<QuerySnapshot>(
                    snapshot: snapshot,
                    builder: (context, data) {
                      final properties = data.docs;
                      final userId =
                          Provider.of<UserProvider>(context, listen: false)
                              .userId;

                      return isTileView
                          ? _buildGridView(properties, userId)
                          : _buildListView(properties, userId);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<QueryDocumentSnapshot> properties, String userId) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
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
              isTileView: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsScreen(
                      userId: userId,
                      propertyAgent: property['propertyAgent'],
                      propertyId: property['propertyId'] ?? '',
                      status: property['status'],
                      sqFt: property['pricePerSqFt'] ?? '0',
                      address: property['address'] ?? 'No Address',
                      name: property['name'] ?? 'No Title',
                      score: property['score']?.toString() ?? '0',
                      image: property['image'] ?? '',
                      hoa: property['hoa'] ?? 'no',
                      lotSize: property['lotSize'] ?? '',
                      yearBuilt: property['yearBuilt'] ?? '',
                    ),
                  ),
                );
              },
              onFavoriteToggle: () {
                firebaseService.toggleFavorite(
                  property['propertyId'] ?? '',
                  property.data() as Map<String, dynamic>,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> properties, String userId) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.64,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsScreen(
                      userId: userId,
                      propertyAgent: property['propertyAgent'] ?? '',
                      propertyId: property['propertyId'] ?? '',
                      status: property['status'],
                      sqFt: property['pricePerSqFt'] ?? '0',
                      address: property['address'] ?? 'No Address',
                      name: property['name'] ?? 'No Title',
                      score: property['score']?.toString() ?? '0',
                      image: property['image'] ?? '',
                      hoa: property['hoa'] ?? 'no',
                      lotSize: property['lotSize'] ?? '',
                      yearBuilt: property['yearBuilt'] ?? '',
                    ),
                  ),
                );
              },
              onFavoriteToggle: () {
                firebaseService.toggleFavorite(
                  property['propertyId'],
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
