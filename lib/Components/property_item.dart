import 'package:flutter/material.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';

class PropertyItem extends StatefulWidget {
  final String image;
  final String title;
  final String address;
  final bool isFavorite;
  final bool isForSale;
  final bool isTileView;
  final int? rating;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  PropertyItem({
    required this.image,
    required this.title,
    required this.address,
    required this.isFavorite,
    required this.isForSale,
    required this.isTileView,
    required this.onTap,
    required FirebaseService firebaseService,
    this.onFavoriteToggle,
    this.rating,
  });

  @override
  State<PropertyItem> createState() => _PropertyItemState();
}

class _PropertyItemState extends State<PropertyItem> {
  @override
  Widget build(BuildContext context) {
    bool isFavorited = widget.isFavorite;

    return SafeArea(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  widget.image,
                  width: double.infinity,
                  height: widget.isTileView ? 120 : 180,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 10),
                        widget.rating == null
                            ? SizedBox()
                            : Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < widget.rating!
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 15,
                                  );
                                }),
                              ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(widget.address,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (widget.isForSale)
                          const Icon(Icons.circle,
                              color: Colors.green, size: 10),
                        if (widget.isForSale) const SizedBox(width: 8),
                        if (widget.isForSale)
                          Text("For sale",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        Spacer(),
                        GestureDetector(
                          child: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorited ? Colors.red : Colors.grey,
                          ),
                          onTap: () async {
                            setState(() {
                              isFavorited = !isFavorited;
                            });

                            if (widget.onFavoriteToggle != null) {
                              widget.onFavoriteToggle!();
                            }
                          },
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
}
