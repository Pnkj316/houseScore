// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:houszscore/Utils/tagCategory.dart';
import 'package:houszscore/Visit%20Review/Visit%20Component/gallery_grid.dart';
import 'package:houszscore/Visit%20Review/Visit%20Component/rating_option.dart';
import 'package:houszscore/Visit%20Review/Visit%20Component/section_header.dart';
import 'package:houszscore/Visit%20Review/header_widget.dart';
import 'package:houszscore/modal/initialize_screen_data.dart';
import 'package:houszscore/modal/screen_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:houszscore/BottomNavBar/bottom_navbar.dart';
import 'package:houszscore/Components/Visiting%20Screen%20components/visiting_component.dart';
import 'package:houszscore/Components/button_widget.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:houszscore/modal/visting_modal.dart';

// ignore: must_be_immutable
class Visiting1Screen extends StatefulWidget {
  final String propertyId;
  final String image;
  final String name;
  final String address;
  final String visitDate;
  final String userId;
  final int rating;
  final VisitingData? visitingData;

  bool isUpdated;

  Visiting1Screen({
    Key? key,
    required this.propertyId,
    required this.image,
    required this.name,
    required this.address,
    required this.visitDate,
    required this.rating,
    this.visitingData,
    required this.isUpdated,
    required this.userId,
  }) : super(key: key);

  @override
  _Visiting1ScreenState createState() => _Visiting1ScreenState();
}

class _Visiting1ScreenState extends State<Visiting1Screen> {
  final Map<String, bool> _isExpanded = {};
  final Map<String, dynamic> _notes = {};
  double hateCount = 0;
  double canLiveWithItCount = 0;
  double loveItCount = 0;
  Map<String, int> ratings = {};
  Map<String, List<XFile>> sectionImages = {};
  Map<String, int> ratingsList = {};
  double? weightedAverage;
  bool isLoading = true;

  Map<String, int> buildRatingDataMap(
      List<ScreenData> screens, Map<String, dynamic> filteredData) {
    final Map<String, int> ratings = {};

    Set<String> uniqueKeys = {
      ...screens
          .where((s) => s.optionType == OptionType.segment)
          .map((s) => formatText(s.text2)),
      ...filteredData.keys.map((key) => formatTitleCase(key)),
    };

    for (var key in uniqueKeys) {
      ratings[key] = widget.visitingData?.partRatings?[key] ?? 2;
    }

    return ratings;
  }

  Map<String, List<XFile>> buildImageDataMap(
      List<ScreenData> screens, Map<String, dynamic> filteredData) {
    final Map<String, List<XFile>> reviewImg = {};

    Set<String> uniqueKeys = {
      ...screens
          .where((s) => s.optionType == OptionType.segment)
          .map((s) => formatText(s.text2)),
      ...filteredData.keys.map((key) => formatTitleCase(key)),
    };

    for (var key in uniqueKeys) {
      var imagesData = widget.visitingData?.notes?[key]?['reviewImg'];

      if (imagesData is List) {
        reviewImg[key] =
            imagesData.map<XFile>((path) => XFile(path.toString())).toList();
      } else {
        reviewImg[key] = [];
      }
    }

    return reviewImg;
  }

  Future<Map<String, dynamic>> filterScreenData(String userId) async {
    final FirebaseService firebaseService = FirebaseService();
    final Map<String, dynamic>? preferences =
        await firebaseService.getPreferences();

    final Set<String> allScreenKeys = ScreenDataInitializer.initializeScreens()
        .map((s) => s.screenKey)
        .toSet();

    if (preferences == null || !preferences.containsKey("prefs")) {
      return {};
    }

    Map<String, dynamic> prefs = preferences["prefs"];

    return Map.fromEntries(
        prefs.entries.where((entry) => !allScreenKeys.contains(entry.key)));
  }

  Future<Map<String, dynamic>> preferencesValues(
      String userId, Map<String, dynamic> ratings) async {
    final FirebaseService firebaseService = FirebaseService();
    final Map<String, dynamic>? preferences =
        await firebaseService.getPreferences();

    final Map<String, dynamic> matchedData = {};

    if (preferences != null && preferences.containsKey("prefs")) {
      Map<String, dynamic> prefs = preferences["prefs"];

      for (var key in ratings.keys) {
        String formattedKey = formatext(key);

        if (prefs.containsKey(formattedKey)) {
          matchedData[formattedKey] = prefs[formattedKey]; // ✅ FIXED
        }
      }
    }

    return matchedData;
  }

  Future<double> calculateWeightedAverage(
    String userId,
    Map<String, dynamic> ratings,
    double hateCount,
    double canLiveWithItCount,
    double loveItCount,
  ) async {
    Map<String, dynamic> matchedPreferences =
        await preferencesValues(userId, ratings);

    int matchedKeysLength = ratings.length;

    if (matchedKeysLength == 0) {
      return 0.0;
    }

    int preferenceValuesSum = matchedPreferences.values
        .fold(0, (sum, value) => sum + (value is int ? value : 0));

    double totalRatings = hateCount + canLiveWithItCount + loveItCount;
    if (totalRatings == 0) return 0.0;

    double totalScore =
        ((0 * hateCount) + (3 * canLiveWithItCount) + (5 * loveItCount));

    double average = totalScore / totalRatings;
    double weightedAverage = (((preferenceValuesSum * 5) - average) * 100) /
        (5 * matchedKeysLength * 5);

    print('weightage average ${weightedAverage}');
    print('HATe average ${hateCount}');
    print('NEUTRAL average ${canLiveWithItCount}');
    print('love average ${loveItCount}');
    return weightedAverage;
  }

  String formatext(String text) {
    return text
        .split(' ')
        .map((word) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ')
        .replaceAll(" ", "_")
        .toLowerCase();
  }

  String formatTitleCase(String text) {
    return text
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String formatText(String text) {
    return text.split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void updateWeightedAverage() async {
    setState(() {
      isLoading = true;
    });

    double newAverage = await calculateWeightedAverage(
      widget.userId,
      ratings,
      hateCount,
      canLiveWithItCount,
      loveItCount,
    );

    setState(() {
      weightedAverage = newAverage;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.visitingData != null) {
      widget.isUpdated = true;
      _initializeExistingData();
    }

    final screens = ScreenDataInitializer.initializeScreens();

    filterScreenData(widget.userId).then((filteredData) {
      preferencesValues(widget.userId, ratings).then((matchedPreferences) {
        setState(() {
          ratings = buildRatingDataMap(screens, filteredData);
          sectionImages = buildImageDataMap(screens, filteredData);
        });
      });
    });

    calculateWeightedAverage(
      widget.userId,
      ratings,
      hateCount,
      canLiveWithItCount,
      loveItCount,
    ).then((value) {
      setState(() {
        weightedAverage = value;
        isLoading = false;
      });
    }).catchError((error) {
      print("Error calculating weighted average: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  void _initializeExistingData() {
    final existingData = widget.visitingData!;

    existingData.partRatings?.forEach((section, rating) {
      if (ratings.containsKey(section)) {
        ratings[section] = rating;
      }
    });
    existingData.notes?.forEach((section, note) {
      _notes[section] = note['note'] ?? '';

      if (note['reviewImg'] != null && note['reviewImg'] is List) {
        var images = (note['reviewImg'] as List<dynamic>)
            .map((path) => XFile(path.toString()))
            .toList();
        sectionImages[section] = images;
      } else {
        sectionImages[section] = [];
      }
    });
  }

  void _handleSubmit(BuildContext context) async {
    if (FirebaseService().currentUser == null) {
      print("No user logged in.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in.")),
      );
      return;
    }

    final Map<String, int> partRatings = {
      for (var section in ratings.keys) section: ratings[section]!,
    };

    Map<String, List<String>> uploadedImageUrls = {};
    FirebaseStorage storage = FirebaseStorage.instance;

    for (var title in sectionImages.keys) {
      List<String> imageUrls = [];
      for (var file in sectionImages[title]!) {
        try {
          String fileName = basename(file.path);
          Reference storageRef = storage.ref().child("images/$fileName");
          UploadTask uploadTask = storageRef.putFile(File(file.path));

          TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
          String imageUrl = await snapshot.ref.getDownloadURL();

          imageUrls.add(imageUrl);
          print("Uploaded Image: $imageUrl");
        } catch (e) {
          print("Error uploading image: $e");
        }
      }

      if (imageUrls.isEmpty) {
        print("No images uploaded for section: $title");
      }

      uploadedImageUrls[title] = imageUrls;
    }

    final Map<String, dynamic> sectionDetails = {
      for (var title in ratings.keys)
        title: {
          "note": _notes[title] ?? '',
          "reviewImg":
              sectionImages[title]?.map((image) => image.path).toList() ?? []
        }
    };

    double wgtScore = await calculateWeightedAverage(
      widget.userId,
      ratings,
      hateCount,
      canLiveWithItCount,
      loveItCount,
    );

    VisitingData visitingData = VisitingData(
      userId: widget.userId,
      wgtScore: wgtScore,
      propertyId: widget.propertyId,
      propertyRating: widget.rating,
      image: widget.image,
      name: widget.name,
      address: widget.address,
      visitDate: widget.visitDate,
      partRatings: partRatings,
      notes: sectionDetails,
    );

    FirebaseService firebaseService = FirebaseService();

    try {
      bool exists = await firebaseService.isPropertyVisited(widget.propertyId);

      if (exists) {
        if (widget.isUpdated) {
          await firebaseService.updateVisitingData(
              widget.propertyId, visitingData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Visiting data updated successfully!')),
          );
        }
      } else {
        await firebaseService.uploadVisitingData(visitingData, context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Visiting data uploaded successfully!')),
        );
      }

      setState(() {});
    } catch (e) {
      print("Error in _handleSubmit: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload/update data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined,
              size: 20, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Visiting',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (weightedAverage != null)
                HeaderWidget(
                  userId: widget.userId,
                  average: weightedAverage!,
                  address: widget.address,
                  image: widget.image,
                  name: widget.name,
                  propertyId: widget.propertyId,
                )
              else
                Text("No data available"),
              SizedBox(height: 20),
              Text(
                "Visited ${widget.visitDate}",
                style: TextStyles.size18Weight500,
              ),
              SizedBox(height: 10),
              for (var title in ratings.keys)
                _buildSection(
                  context,
                  title,
                  isExpanded: _isExpanded[title] ?? false,
                  onToggle: () {
                    setState(() {
                      _isExpanded[title] = !(_isExpanded[title] ?? false);
                    });
                  },
                  selectedRating: ratings[title]!,
                  onRatingChanged: (newRating) =>
                      _updateRating(title, newRating),
                  galleryImages: sectionImages[title] ?? [],
                  notes: _notes[title] ?? '',
                ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonWidget(
                    height: 40,
                    width: 150,
                    label: "Submit",
                    onTap: () {
                      _handleSubmit(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => BottomNavbar()));
                    },
                    color: AppColor.blue,
                    txtColor: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title,
      {required bool isExpanded,
      required VoidCallback onToggle,
      required int selectedRating,
      required String notes,
      required Function(int) onRatingChanged,
      required List<XFile> galleryImages}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColor.lightGrey),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: title,
              isExpanded: isExpanded,
              onToggle: onToggle,
            ),
            if (isExpanded)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RatingOption(
                        icon: Icons.sentiment_very_dissatisfied,
                        label: "Hate it",
                        section: title,
                        userId: widget.userId,
                        selected: selectedRating == 0,
                        onRatingSelected: _updateRating,
                      ),
                      RatingOption(
                        icon: Icons.sentiment_neutral,
                        label: "Can live with it",
                        section: title,
                        userId: widget.userId,
                        selected: selectedRating == 3,
                        onRatingSelected: _updateRating,
                      ),
                      RatingOption(
                        icon: Icons.sentiment_very_satisfied,
                        label: "Love it",
                        section: title,
                        userId: widget.userId,
                        selected: selectedRating == 5,
                        onRatingSelected: _updateRating,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "My Notes",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: Image.asset(AppIcon.edit, scale: 3.5),
                              onPressed: () {
                                _showNoteWithTagsModal(context, title);
                              },
                            ),
                          ],
                        ),
                        Text(
                          notes,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Gallery",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: Image.asset(AppIcon.cam, scale: 3.5),
                              onPressed: () async {
                                if ((sectionImages[title]?.length ?? 0) < 4) {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                      source: ImageSource.camera);
                                  if (image != null) {
                                    setState(() {
                                      sectionImages[title]?.add(image);
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'You can only upload 4 images.')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        if (galleryImages.isNotEmpty)
                          GalleryGrid(
                            galleryImages: galleryImages,
                            onRemoveImage: (index) {
                              setState(() {
                                galleryImages.removeAt(index);
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _updateRating(String section, int rating) async {
    setState(() {
      ratings[section] = rating;
      ratingsList[section] = rating;

      hateCount = 0;
      canLiveWithItCount = 0;
      loveItCount = 0;

      ratingsList.forEach((section, rating) {
        if (rating == 0) {
          hateCount += 1;
        } else if (rating == 3) {
          canLiveWithItCount += 1;
        } else if (rating == 5) {
          loveItCount += 1;
        }
      });
    });

    double newAverage = await calculateWeightedAverage(
      widget.userId,
      ratings,
      hateCount,
      canLiveWithItCount,
      loveItCount,
    );

    setState(() {
      weightedAverage = newAverage;
    });
  }

  _showNoteWithTagsModal(BuildContext context, String section) {
    final selectedTags = <String>{};
    final sectionTagData = sectionTags[section];

    if (sectionTagData == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return NoteWithTagsModal(
          section: section,
          initialSelectedTags: selectedTags.toList(),
          onSave: (note, tags) {
            setState(() {
              _notes[section] = note;
              selectedTags.clear();
              selectedTags.addAll(tags);
            });
          },
        );
      },
    );
  }
}
