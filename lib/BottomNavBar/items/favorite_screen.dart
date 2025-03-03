import 'package:flutter/material.dart';
import 'package:houszscore/Components/property_item.dart';
import 'package:houszscore/Components/toggle_button.dart';
import 'package:houszscore/Components/detail_screen.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isTileView = false;

  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 244, 248),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              "Favorites",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: firebaseService.getFavorites(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No favorites added yet."));
                  }

                  final favoriteProperties = snapshot.data!;

                  return isTileView
                      ? _buildGridView(favoriteProperties)
                      : _buildListView(favoriteProperties);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> favoriteProperties) {
    return ListView.builder(
      itemCount: favoriteProperties.length,
      itemBuilder: (context, index) {
        final property = favoriteProperties[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: PropertyItem(
            firebaseService: firebaseService,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyDetailsScreen(
                    userId: property['userId'] ?? '',
                    propertyAgent: property['propertyAgent'] ?? '',
                    propertyId: property['propertyId'] ?? '',
                    status: property['status'] ?? '',
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
            image: property['image'] ?? '',
            title: property['name'] ?? '',
            address: property['address'] ?? "",
            isTileView: false,
            isForSale: property['isForSale'] ?? true,
            isFavorite: true,
            onFavoriteToggle: () async {
              await _toggleFavorite(property);
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> favoriteProperties) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: favoriteProperties.length,
      itemBuilder: (context, index) {
        final property = favoriteProperties[index];
        return PropertyItem(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertyDetailsScreen(
                  userId: property['userId'] ?? '',
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
          firebaseService: firebaseService,
          image: property['image'] ?? '',
          title: property['name'] ?? '',
          address: property['address'] ?? "",
          isTileView: true,
          isForSale: property['isForSale'] ?? true,
          isFavorite: true,
          onFavoriteToggle: () async {
            await _toggleFavorite(property);
          },
        );
      },
    );
  }

  Future<void> _toggleFavorite(Map<String, dynamic> property) async {
    final propertyId = property['propertyId'];
    if (propertyId == null) return;

    await FirebaseService().toggleFavorite(propertyId, property);

    setState(() {});
  }
}
