import 'package:flutter/material.dart';

class RatingSection extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onDetailsPressed;
  final String detailsText;
  final TextStyle detailsTextStyle;

  const RatingSection({
    Key? key,
    this.initialRating = 1,
    required this.onRatingChanged,
    required this.onDetailsPressed,
    this.detailsText = 'Details',
    this.detailsTextStyle = const TextStyle(
        color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600),
  }) : super(key: key);

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStarRating(),
          TextButton(
            onPressed: widget.onDetailsPressed,
            child: Text(
              widget.detailsText,
              style: widget.detailsTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _currentRating = index + 1;
              widget.onRatingChanged(_currentRating);
            });
          },
        );
      }),
    );
  }
}
