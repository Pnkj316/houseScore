import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houszscore/BottomNavBar/Provider/userid_provider.dart';
import 'package:houszscore/Components/favorite_button.dart';
import 'package:houszscore/Components/star_score.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/Visit%20Review/visting1_screen.dart';
import 'package:houszscore/Components/detail_screen.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:houszscore/modal/visting_modal.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onChangeTab;

  const HomeScreen({required this.onChangeTab, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return SafeArea(
      child: Container(
        color: const Color.fromARGB(255, 238, 244, 248),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          children: [
            _buildSectionTitle('My Favourites', () => widget.onChangeTab(2)),
            SizedBox(height: 10.h),
            _buildLiveStreamSection(
                _buildFavouriteItem, 80.h, firebaseService.getFavorites()),
            SizedBox(height: 20.h),
            _buildSectionTitle('Recommendations', () => widget.onChangeTab(1)),
            SizedBox(height: 10.h),
            _buildRecommandSection(_buildRecommendationItem, 250.h,
                firebaseService.getRecommendations()),
            SizedBox(height: 20.h),
            _buildSectionTitle(
              'Visited',
              () => widget.onChangeTab(3),
            ),
            SizedBox(height: 10.h),
            _buildLiveStreamSection(
                _buildVisitedItem, 80.h, firebaseService.getVisits()),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.size20Weight600),
          GestureDetector(
            onTap: onTap,
            child: Text('SEE ALL',
                style:
                    TextStyles.size14Weight400.copyWith(color: AppColor.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommandSection(
      Widget Function(BuildContext, Map<String, dynamic>) itemBuilder,
      double height,
      Stream<List<Map<String, dynamic>>> stream) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available.'));
        }

        return Container(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, snapshot.data![index]),
          ),
        );
      },
    );
  }

  Widget _buildLiveStreamSection(
    Widget Function(BuildContext, Map<String, dynamic>) itemBuilder,
    double height,
    Stream<List<Map<String, dynamic>>> stream,
  ) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available.'));
        }

        String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
        if (currentUserId == null) {
          return Center(child: Text('No data available.'));
        }

        List<Map<String, dynamic>> filteredData = snapshot.data!
            .where((data) => data['userId'] == currentUserId)
            .toList();

        if (filteredData.isEmpty) {
          return Center(child: Text('No data available.'));
        }

        return Container(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredData.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, filteredData[index]),
          ),
        );
      },
    );
  }

  Widget _buildFavouriteItem(BuildContext context, Map<String, dynamic> data) {
    final imageUrl = data['image'] ?? '';
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute) {
      return Center(
        child: Icon(Icons.image_not_supported, size: 50),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsScreen(
                userId: data['userId'] ?? '',
                propertyAgent: data['propertyAgent'] ?? '',
                propertyId: data['propertyId'] ?? '',
                status: data['status'],
                sqFt: data['pricePerSqFt'] ?? '0',
                address: data['address'] ?? 'No Address',
                name: data['name'] ?? 'No Title',
                score: data['score']?.toString() ?? '0',
                image: data['image'] ?? '',
                hoa: data['hoa'] ?? 'no',
                lotSize: data['lotSize'] ?? '',
                yearBuilt: data['yearBuilt'] ?? '',
              ),
            ),
          );
        },
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.network(
              imageUrl,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.image_not_supported, size: 50),
                );
              },
            ),
          ),
          Positioned(
              top: 7.h,
              right: 8.w,
              child: StarScore(
                userId: userId,
                propertyId: data['propertyId'] ?? '',
                fontSize: 12,
                height: 25,
              )),
        ]),
      ),
    );
  }

  Widget _buildRecommendationItem(
      BuildContext context, Map<String, dynamic> data) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsScreen(
                userId: userId,
                propertyAgent: data['propertyAgent'] ?? '',
                propertyId: data['propertyId'] ?? '',
                status: data['status'],
                sqFt: data['pricePerSqFt'] ?? '0',
                address: data['address'] ?? 'No Address',
                name: data['name'] ?? 'No Title',
                score: data['score']?.toString() ?? '0',
                image: data['image'] ?? '',
                hoa: data['hoa'] ?? 'no',
                lotSize: data['lotSize'] ?? '',
                yearBuilt: data['yearBuilt'] ?? '',
              ),
            ),
          );
        },
        child: Container(
          width: 250.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Image.network(
                  data['image'] ?? '',
                  width: 250.w,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['name'] ?? 'No Title',
                          style: TextStyles.size16Weight600,
                        ),
                        StarScore(
                          userId: userId,
                          fontSize: 18,
                          height: 40,
                          propertyId: data['propertyId'] ?? '',
                        )
                      ],
                    ),
                    Text(
                      data['address'] ?? 'No Address',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 11.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: const Color.fromARGB(255, 114, 208, 127),
                              size: 10.sp,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              'Open house',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                        SizedBox(width: 60.w),
                        FavoriteButton(
                          propertyId: data['propertyId'] ?? '',
                          propertyData: data,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitedItem(BuildContext context, Map<String, dynamic> data) {
    final image = data['image'] ?? '';
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (image.isEmpty || !Uri.parse(image).isAbsolute) {
      return Center(
        child: Icon(Icons.image_not_supported, size: 50),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () {
          final visitingData = VisitingData.fromJson(data);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Visiting1Screen(
                userId: userId,
                isUpdated: true,
                propertyId: data['propertyId'] ?? '',
                visitDate: data['visitDate'] ?? '',
                address: data['address'] ?? 'No Address',
                name: data['name'] ?? 'No Title',
                image: data['image'] ?? '',
                rating: data['propertyRating'] ?? '',
                visitingData: visitingData,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.network(
                image,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                top: 10.h,
                right: 10.w,
                child: StarScore(
                  userId: userId,
                  propertyId: data['propertyId'] ?? '',
                  fontSize: 12,
                  height: 25,
                )),
          ],
        ),
      ),
    );
  }
}
