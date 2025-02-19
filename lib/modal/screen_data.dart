class ScreenData {
  final String screenKey;
  final String text;
  final String text2;
  final String imageUrl;
  final OptionType optionType;
  final Map<String, int>? options;
  final double? minValue;
  final double? maxValue;

  ScreenData({
    required this.screenKey,
    required this.text,
    required this.text2,
    required this.imageUrl,
    required this.optionType,
    this.options,
    this.minValue,
    this.maxValue,
  });
}

enum OptionType { radio, slider, segment }
