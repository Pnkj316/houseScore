import 'package:houszscore/Utils/app_img.dart';
import 'package:houszscore/modal/screen_data.dart';

class ScreenDataInitializer {
  static List<ScreenData> initializeScreens() {
    return [
      ..._buildScreenData(
          AppImage.kitchen,
          "How important is the kitchen in your home search?",
          "KITCHEN",
          "kitchen"),
      ..._buildScreenData(
          AppImage.bedroom,
          "How Important is the master bedroom for your need?",
          "MASTER BEDROOM",
          "master_bedroom"),
      ..._buildScreenData(
          AppImage.bedroom,
          "How Important are extra bedrooms to you?",
          "ADDITIONAL BEDROOMS",
          "additional_bedrooms"),
      ..._buildScreenData(
          AppImage.bedroom,
          "How Important is having a guest bedroom?",
          "GUEST BEDROOM",
          "guest_bedroom"),
      ..._buildScreenData(
          AppImage.bathroom,
          "How Important is a home office for your lifestyle?",
          "HOME OFFICE",
          "home_office"),
      ..._buildScreenData(
          AppImage.garage,
          "How Important is a well-designed bathroom to you?",
          "BATHROOM",
          "bathroom"),
      ..._buildScreenData(AppImage.garage, "How Important is having a garage?",
          "GARAGE", "garage"),
      ..._buildScreenData(AppImage.good_view,
          "How Important is having a good view?", "VIEW", "view"),
      ..._buildRadioScreen(
          AppImage.num_bedroom,
          "Minimum number of bedrooms",
          "BEDROOMS",
          {"1": 1, "2": 2, "3": 3, "4": 4, "5+": 5},
          "bedroom_number"),
      ..._buildRadioScreen(
          AppImage.num_bathroom,
          "Minimum number of bathrooms",
          "BATHROOMS",
          {"1": 1, "2": 2, "2.5": 3, "3": 4, "4+": 5},
          "bathroom_number"),
      ..._buildRadioScreen(
          AppImage.garage_size,
          "What is your preferred Garage size?",
          "GARAGE",
          {"1": 1, "2": 2, "2.5": 3, "3": 4, "4+": 5},
          "garge_size"),
      ..._buildScreenData(
          AppImage.cul_de,
          "How important is the living room to you?",
          "LIVING ROOM",
          "living_room"),
      ..._buildSliderScreen(
          AppImage.square_ft,
          "What is the minimum total square footage you are looking for",
          "TOTAL SQ FOOTAGE",
          5000,
          0,
          "total_sqft"),
      ..._buildSliderScreen(
          AppImage.price,
          "What is the maximum price you want to pay?",
          "PRICE PAY",
          500000,
          50000,
          "maximum_price"),
      ..._buildScreenData(
          AppImage.ceiling,
          "How important is staying within your price range?",
          "PRICE",
          "price"),
      ..._buildScreenData(
          AppImage.price,
          "How important is having a basement for your needs?",
          "BASEMENT",
          "basement"),
      ..._buildSliderScreen(
          AppImage.sq_ft,
          "What is the maximum price per square foot?",
          "PRICE PER SQUARE FOOT",
          1500,
          100,
          "maximum_price_per_sqft"),
      ..._buildScreenData(AppImage.Hao,
          "How important is having an HOA in yor decision?", "HOA", "hoa"),
      ..._buildScreenData(
          AppImage.nearby,
          "How important are nearby schools for your family?",
          "SCHOOLS",
          "schools"),
      ..._buildScreenData(AppImage.backyard,
          "How important is having a backyard?", "BACKYARD", "backyard"),
      ..._buildScreenData(AppImage.split,
          "How important is a front yard to you?", "FRONT YARD", "front_yard"),
      ..._buildScreenData(
          AppImage.ranch, "How important is having a pool?", "POOL", "pool"),
      ..._buildScreenData(
          AppImage.fav1,
          'How important is having a dining room?',
          'DINING ROOM',
          'dining_room'),
      ..._buildScreenData(
          AppImage.fav1,
          'How important is the size of the house(sq ft) to you?',
          'HOUSE SIZE',
          'house_size'),
      ..._buildScreenData(
          AppImage.fav1,
          'How important is the overall look and feel of the house?',
          'OVERALL HOUSE',
          'overall_house'),
      ..._buildScreenData(
          AppImage.fav1,
          'How important is the neighborhood in your home choice?',
          'NEIGHBORHOOD',
          'neighborhood')
    ];
  }

  static List<ScreenData> _buildScreenData(
      String imageUrl, String text, String text2, String key) {
    return [
      ScreenData(
        screenKey: key,
        optionType: OptionType.segment,
        text: text,
        text2: text2,
        imageUrl: imageUrl,
        options: {
          "Not Important": 1,
          "Slightly Important": 2,
          "Moderately Important": 3,
          "Very Important": 4,
          "Extremely Important": 5
        },
      ),
    ];
  }

  static List<ScreenData> _buildRadioScreen(
    String imageUrl,
    String text,
    String text2,
    Map<String, int> options,
    String key,
  ) {
    return [
      ScreenData(
        screenKey: key,
        optionType: OptionType.radio,
        text: text,
        text2: text2,
        imageUrl: imageUrl,
        options: options,
      ),
    ];
  }

  static List<ScreenData> _buildSliderScreen(String imageUrl, String text,
      String text2, double maxValue, double minValue, String key) {
    return [
      ScreenData(
        screenKey: key,
        optionType: OptionType.slider,
        text: text,
        text2: text2,
        imageUrl: imageUrl,
        maxValue: maxValue,
        minValue: minValue,
      ),
    ];
  }
}
