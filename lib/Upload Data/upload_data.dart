import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houszscore/data/dummyData.dart';
import 'package:image_picker/image_picker.dart';

class UploadData extends StatefulWidget {
  @override
  _UploadDataState createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<String> uploadImageFromAssets(
      String assetPath, String imageName) async {
    try {
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List imageBytes = byteData.buffer.asUint8List();

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child('property_images/$imageName');
      UploadTask uploadTask = storageRef.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image from assets: $e');
      return '';
    }
  }

  Future<void> uploadAllPropertyData() async {
    if (_isUploading) return;

    setState(() {
      _isUploading = true;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Future> uploadFutures = [];

    for (var property in dummyData) {
      String imageName = 'image_${property['propertyId']}';
      String assetPath = property['image'];
      uploadFutures
          .add(uploadImageFromAssets(assetPath, imageName).then((imageUrl) {
        if (imageUrl.isNotEmpty) {
          property['image'] = imageUrl;

          firestore.collection('properties').doc(property['propertyId']).set({
            "propertyAgent": property['propertyAgent'],
            "propertyId": property['propertyId'],
            "name": property['name'],
            "address": property['address'],
            "openHouse": DateTime.now(),
            "pricePerSqFt": property['pricePerSqFt'],
            "yearBuilt": property['yearBuilt'],
            "lotSize": property['lotSize'],
            "hoa": property['hoa'],
            "status": property['status'],
            "score": property['score'],
            "image": property['image'],
            "favorite": false,
            "visited": false,
            "recommended": true,
          }).then((_) {
            print('Property ${property['propertyId']} uploaded successfully');
          }).catchError((e) {
            print('Error uploading property data: $e');
          });
        }
      }));
    }

    await Future.wait(uploadFutures);

    setState(() {
      _isUploading = false;
    });

    print('All properties uploaded successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Property Data'),
      ),
      body: Center(
        child: _isUploading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: uploadAllPropertyData,
                    child: Text('Upload All Properties'),
                  ),
                  SizedBox(height: 20),
                  if (_isUploading) CircularProgressIndicator(),
                ],
              ),
      ),
    );
  }
}
