import 'package:flutter/material.dart';
import 'package:houszscore/Components/star_score.dart';

class HeaderWidget extends StatelessWidget {
  final String image;
  final String name;
  final String propertyId;
  final String userId;
  final String address;
  final double average;

  const HeaderWidget({
    Key? key,
    required this.image,
    required this.name,
    required this.address,
    required this.average,
    required this.propertyId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => _buildDot(index == 0)),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            StarScore(
              userId: userId,
              propertyId: propertyId,
              height: 60,
              fontSize: 28,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.grey[400],
      ),
    );
  }
}
