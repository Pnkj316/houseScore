import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryGrid extends StatelessWidget {
  final List<XFile> galleryImages;
  final Function(int) onRemoveImage;

  const GalleryGrid({
    Key? key,
    required this.galleryImages,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: 15),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1.2,
      ),
      itemCount: galleryImages.length,
      itemBuilder: (context, index) {
        return Stack(
          alignment: Alignment.topRight,
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                File(galleryImages[index].path),
                fit: BoxFit.fill,
                scale: 3,
              ),
            ),
            GestureDetector(
              onTap: () => onRemoveImage(index),
              child: Icon(
                Icons.remove_circle,
                color: Colors.black,
                size: 15,
              ),
            ),
          ],
        );
      },
    );
  }
}
