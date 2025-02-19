import 'package:flutter/material.dart';
import 'package:houszscore/Preferences/preference_manager_screen.dart';
import 'package:houszscore/Utils/app_img.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:houszscore/modal/screen_data.dart';

class PreferenceQuestions extends StatefulWidget {
  final String userId;
  final List<ScreenData> screenDataList;
  final Function(String)? onCustomCriteriaAdded;

  const PreferenceQuestions({
    super.key,
    required this.screenDataList,
    required this.userId,
    this.onCustomCriteriaAdded,
  });

  @override
  State<PreferenceQuestions> createState() => _PreferenceQuestionsState();
}

class _PreferenceQuestionsState extends State<PreferenceQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preference', style: TextStyles.size22Weight600),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: FirebaseService().getPreferences(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No preferences found.'));
                  }

                  var preferences =
                      snapshot.data!['prefs'] as Map<String, dynamic>;

                  preferences.forEach((key, value) {
                    bool isMatchFound = widget.screenDataList
                        .any((screenData) => screenData.screenKey == key);
                    if (!isMatchFound) {
                      ScreenData customScreenData = ScreenData(
                        screenKey: key,
                        text: "How important is the ${key} for you?",
                        optionType: OptionType.segment,
                        text2: '${key.toUpperCase()}',
                        options: {
                          "Not Important": 1,
                          "Slightly Important": 2,
                          "Moderately Important": 3,
                          "Very Important": 4,
                          "Extremely Important": 5
                        },
                        imageUrl: AppImage.whiteWall,
                      );

                      if (widget.onCustomCriteriaAdded != null) {
                        widget.onCustomCriteriaAdded!(key);
                      }
                      widget.screenDataList.add(customScreenData);
                    }
                  });

                  return ListView.builder(
                    itemCount: widget.screenDataList.length,
                    itemBuilder: (context, index) {
                      ScreenData screenData = widget.screenDataList[index];

                      final preferenceValue = preferences[screenData.screenKey];

                      String displayValue = 'No preference selected';
                      if ((screenData.optionType == OptionType.segment ||
                              screenData.optionType == OptionType.radio) &&
                          screenData.options != null) {
                        screenData.options!.forEach((key, value) {
                          if (value == preferenceValue) {
                            displayValue = key;
                          }
                        });
                      } else if (preferenceValue != null) {
                        displayValue = preferenceValue.toString();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.top,
                            title: Text(screenData.text,
                                style: TextStyles.size16Weight500),
                            subtitle: Text(displayValue,
                                style: TextStyles.size16Weight500
                                    .copyWith(color: Colors.grey)),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreferenceManager(
                                      isUpdate: true,
                                      userId: widget.userId,
                                      initialText2: screenData.text2,
                                      initialPreferenceValue: displayValue,
                                      screenDataList:
                                          widget.screenDataList.length),
                                ),
                              );
                            },
                          ),
                          Divider(height: 1, color: Colors.grey.shade300),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
