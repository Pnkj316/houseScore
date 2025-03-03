import 'package:flutter/material.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_img.dart';
import 'package:houszscore/Components/detail_screen.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';

class VictoriaAgentWidget extends StatelessWidget {
  final String propertyAgent;

  const VictoriaAgentWidget({super.key, required this.propertyAgent});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseService().getAgentData(propertyAgent),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Error loading agent data.'));
        }

        final agentData = snapshot.data!;
        if (agentData.isEmpty) {
          return const Center(child: Text('No agent data available.'));
        }

        return _buildAgentWidget(context, agentData[0]);
      },
    );
  }

  Widget _buildAgentWidget(
      BuildContext context, Map<String, dynamic> agentData) {
    final agentName = agentData['name'] ?? 'Unknown Agent';
    final agentImage = agentData['imageUrl'] ?? AppImage.whiteWall;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: GestureDetector(
        onTap: () => _showBottomModalSheet(context, agentData),
        child: Container(
          padding: const EdgeInsets.all(2),
          width: 220,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.blue,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(agentImage),
              ),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'YOUR AGENT',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    agentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Image.asset(
                'assets/icons/message.png',
                scale: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomModalSheet(
      BuildContext context, Map<String, dynamic> agentData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  _buildModalHeader(context),
                  _buildAgentDetails(agentData),
                  _buildAgentBio(agentData),
                  _buildListingSales(agentData),
                  _buildActions(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 15,
                ),
              ),
            ),
          ),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildAgentBio(Map<String, dynamic> agentData) {
    final bio = agentData['bio'] ??
        'I am a Bay Area native, born and raised in San Francisco. Later, I moved to the East Bay, where I purchased and sold property. With 15 years of experience in real estate, I have come to understand the complexities of the buying and selling processes and the importance of working with a knowledgeable and effective agent. You can rest assured that I will be your strongest advocate in the purchase of your dream home.';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        bio,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildAgentDetails(Map<String, dynamic> agentData) {
    final agentName = agentData['name'] ?? 'Unknown Agent';
    final agentLicense = agentData['licenseNumber'] ?? 'No License';
    final agentEmail = agentData['email'] ?? 'No Email';
    final agentPhone = agentData['phone'] ?? 'No Phone';
    final agentImage = agentData['imageUrl'] ?? AppImage.whiteWall;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(agentImage),
          ),
        ),
        Text(
          agentName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Text(
          'License #$agentLicense',
          style: const TextStyle(color: Colors.grey),
        ),
        const Divider(),
        Text(agentEmail, style: const TextStyle(fontSize: 14)),
        const Divider(),
        Text(agentPhone, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildListingSales(Map<String, dynamic> agentData) {
    final propertyIds = List<String>.from(agentData['propertyIds'] ?? []);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPropertyData(propertyIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text("Error loading listings."));
        }

        final properties = snapshot.data!;
        if (properties.isEmpty) {
          return const Center(child: Text("No listings available."));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Listing Sales',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  ...properties.map((property) {
                    final imageUrl = property['imageUrl'] ?? '';
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetailsScreen(
                                  userId: property['userId'] ?? 'N/A',
                                  address: property['address'] ?? 'N/A',
                                  hoa: property['hoa'] ?? 'N/A',
                                  image: property['image'] ?? '',
                                  lotSize: property['lotSize'] ?? 'N/A',
                                  name: property['name'] ?? 'N/A',
                                  propertyAgent:
                                      property['propertyAgent'] ?? 'N/A',
                                  propertyId: property['propertyId'],
                                  score: property['score']?.toString() ?? 'N/A',
                                  sqFt: property['pricePerSqFt']?.toString() ??
                                      'N/A',
                                  status: property['status'] ?? 'N/A',
                                  yearBuilt:
                                      property['yearBuilt']?.toString() ??
                                          'N/A',
                                ),
                              ));
                        },
                        child: _buildImageCard(imageUrl));
                  }).toList(),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildImageCard(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchPropertyData(
      List<String> propertyIds) async {
    List<Map<String, dynamic>> propertiesData = [];

    try {
      for (String propertyId in propertyIds) {
        final docSnapshot = await FirebaseService().getRecommend(propertyId);

        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          final imageUrl = data['image'] ?? 'https://via.placeholder.com/150';

          propertiesData.add({
            'id': docSnapshot.id,
            'imageUrl': imageUrl,
            ...data,
          });
        }
      }
      return propertiesData;
    } catch (e) {
      debugPrint("Error fetching properties data: $e");
      throw Exception('Failed to fetch properties data');
    }
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.blue,
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.call_outlined, color: Colors.white, size: 15),
                SizedBox(width: 5),
                Text('Book a call', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              children: const [
                Icon(Icons.mail_outlined, color: Colors.black, size: 15),
                SizedBox(width: 5),
                Text('Contact', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
