import 'package:flutter/material.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';

class FavoriteButton extends StatefulWidget {
  final String propertyId;
  final String userId;
  final Map<String, dynamic> propertyData;
  final IconData favoriteIcon;
  final IconData notFavoriteIcon;

  const FavoriteButton({
    Key? key,
    required this.propertyId,
    required this.propertyData,
    this.favoriteIcon = Icons.favorite,
    this.notFavoriteIcon = Icons.favorite_border,
    required this.userId,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final isFavorite = await _firebaseService.isFavorite(widget.propertyId);

      setState(() {
        _isFavorite = isFavorite;
      });
    } catch (e) {
      print("Error checking favorite status: ${e.toString()}");
      setState(() {
        _isFavorite = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await FirebaseService().toggleFavorite(
        widget.propertyId,
        widget.propertyData,
      );

      bool isFavorite = await FirebaseService().isFavorite(widget.propertyId);

      setState(() {
        _isFavorite = isFavorite;
      });
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isFavorite ? widget.favoriteIcon : widget.notFavoriteIcon),
      color: _isFavorite ? Colors.red : Colors.grey,
      onPressed: _toggleFavorite,
    );
  }
}
