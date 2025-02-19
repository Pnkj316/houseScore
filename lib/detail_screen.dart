import 'package:flutter/material.dart';
import 'package:houszscore/BottomNavBar/Provider/userid_provider.dart';
import 'package:houszscore/Components/rating_section.dart';
import 'package:houszscore/Components/star_score.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:houszscore/modal/visting_modal.dart';
import 'package:intl/intl.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:houszscore/Components/pricing_plan_screen.dart';
import 'package:houszscore/Components/victoria_agent.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/Visit%20Review/visting1_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String name,
      address,
      score,
      image,
      yearBuilt,
      hoa,
      status,
      sqFt,
      lotSize,
      propertyId,
      userId,
      propertyAgent;

  const PropertyDetailsScreen({
    super.key,
    required this.name,
    required this.address,
    required this.score,
    required this.image,
    required this.yearBuilt,
    required this.hoa,
    required this.status,
    required this.sqFt,
    required this.lotSize,
    required this.propertyId,
    required this.propertyAgent,
    required this.userId,
  });

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _showRating = false;
  int _ratings = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: VictoriaAgentWidget(
        propertyAgent: widget.propertyAgent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.image,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            buildPropertyDetail(),
            buildGreyContainer(),
            const SizedBox(height: 16),
            _buildGridCount(),
            _buildSection("About", _buildAboutContent()),
            _buildSection("Map", _buildMap()),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('Details', style: TextStyles.size20Weight600),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.btnGrey),
    );
  }

  Widget buildPropertyDetail() {
    return buildPadding(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name, style: TextStyles.size20Weight600),
              const SizedBox(height: 4),
              Text(widget.address,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          StarScore(
            userId: widget.userId,
            fontSize: 24,
            height: 55,
            propertyId: widget.propertyId,
          ),
        ],
      ),
    );
  }

  Widget buildGreyContainer() {
    return Container(
      padding: _showRating ? const EdgeInsets.all(1) : const EdgeInsets.all(16),
      color: AppColor.lightGrey,
      child: _showRating
          ? RatingSection(
              onDetailsPressed: () {
                setState(() {
                  _showRating = false;
                });
              },
              detailsText: "Details",
              initialRating: _ratings,
              onRatingChanged: (newRating) async {
                setState(() {
                  _ratings = newRating;
                });
              })
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildRowWithAction(
                  text: 'Open house Today, 30 May',
                  onTapText: () {
                    setState(() {
                      _showRating = true;
                    });
                  },
                  action: 'BOOK A TOUR',
                  onTapIcon: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PricingPlanScreen()),
                  ),
                ),
                const Divider(height: 20),
                buildRowWithAction(
                  text: 'RECORD THE VISIT',
                  onTapText: () async {
                    final userId =
                        Provider.of<UserProvider>(context, listen: false)
                            .userId;

                    DateTime currentDate = DateTime.now();
                    String formattedDate =
                        DateFormat('d MMMM yyyy').format(currentDate);

                    FirebaseService firebaseService = FirebaseService();

                    try {
                      bool exists = await firebaseService
                          .isPropertyVisited(widget.propertyId);

                      if (exists) {
                        final stream = firebaseService.getVisits();
                        final existingDataList = await stream.first;

                        if (existingDataList.isNotEmpty) {
                          VisitingData visitingData =
                              VisitingData.fromJson(existingDataList.first);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Visiting1Screen(
                                userId: visitingData.userId,
                                isUpdated: true,
                                propertyId: visitingData.propertyId,
                                rating: visitingData.propertyRating,
                                image: visitingData.image,
                                address: visitingData.address,
                                name: visitingData.name,
                                visitDate: visitingData.visitDate,
                                visitingData: visitingData,
                              ),
                            ),
                          );
                        }
                      } else {
                        VisitingData newVisitingData = VisitingData(
                          propertyId: widget.propertyId,
                          userId: userId,
                          image: widget.image,
                          address: widget.address,
                          name: widget.name,
                          visitDate: formattedDate,
                          propertyRating: _ratings,
                        );

                        await firebaseService
                            .uploadVisitingData(newVisitingData);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Visiting1Screen(
                              userId: newVisitingData.userId,
                              isUpdated: false,
                              propertyId: newVisitingData.propertyId,
                              rating: newVisitingData.propertyRating,
                              image: newVisitingData.image,
                              address: newVisitingData.address,
                              name: newVisitingData.name,
                              visitDate: newVisitingData.visitDate,
                              visitingData: newVisitingData,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      print("Error handling visit: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("An error occurred. Please try again.")),
                      );
                    }
                  },
                  icon: const CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColor.blue,
                    child:
                        Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGridCount() {
    return buildPadding(
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 15,
        mainAxisSpacing: 10,
        childAspectRatio: 2.9,
        children: [
          _buildPropertyAttribute(label: 'On HowScore', value: widget.score),
          _buildPropertyAttribute(label: 'Year Built', value: widget.yearBuilt),
          _buildPropertyAttribute(label: '\$/Sq Ft', value: '\$${widget.sqFt}'),
          _buildPropertyAttribute(
              label: 'Lot Size', value: '${widget.lotSize} Acres'),
          _buildPropertyAttribute(label: 'HOA', value: widget.hoa),
          _buildPropertyAttribute(label: 'Status', value: widget.status),
        ],
      ),
    );
  }

  Widget _buildAboutContent() {
    return const Text(
      'Indulge in the pinnacle of luxury living in this stunning home nestled on an almost acre corner lot, boasting breathtaking views of Mt. Diablo. '
      'This exquisite property features five spacious bedrooms and four luxurious bathrooms, providing ample space for relaxation and privacy.',
      style: TextStyles.size16Weight400,
    );
  }

  Widget _buildMap() {
    return Container(
      height: 200,
      width: double.infinity,
      child: FlutterMap(
        options: MapOptions(center: LatLng(47.6062, -122.3321), zoom: 12),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(47.6062, -122.3321),
                builder: (ctx) =>
                    const Icon(Icons.location_pin, color: Colors.red, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRowWithAction({
    required String text,
    String? action,
    Widget? icon,
    VoidCallback? onTapIcon,
    VoidCallback? onTapText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTapText,
          child: Text(
            text,
            style: TextStyles.size14Weight500.copyWith(color: AppColor.blue),
          ),
        ),
        GestureDetector(
          onTap: onTapIcon,
          child: action != null
              ? Text(
                  action,
                  style: const TextStyle(
                    color: AppColor.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                )
              : icon ?? Container(),
        ),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return buildPadding(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.size16Weight600),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Padding buildPadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: child,
    );
  }

  Widget _buildPropertyAttribute(
      {required String label, required String value}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
