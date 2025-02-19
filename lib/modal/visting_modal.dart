class VisitingData {
  final String propertyId;
  final String userId;
  final String image;
  final String name;
  final String address;
  final String visitDate;
  final int propertyRating;
  final double? wgtScore;
  final Map<String, int>? partRatings;
  final Map<String, dynamic>? notes;

  VisitingData({
    required this.userId,
    required this.image,
    required this.name,
    required this.address,
    required this.visitDate,
    required this.propertyRating,
    this.partRatings,
    this.notes,
    this.wgtScore,
    required this.propertyId,
  });

  factory VisitingData.fromJson(Map<String, dynamic> json) {
    return VisitingData(
      propertyId: json['propertyId'] as String? ?? 'Unknown ID',
      userId: json['userId'] as String? ?? 'Unknown ID',
      image: json['image'] as String? ?? '',
      name: json['name'] as String? ?? 'No Name',
      address: json['address'] as String? ?? 'No Address',
      visitDate: json['visitDate'] as String? ?? 'Unknown Date',
      propertyRating: (json['propertyRating']) ?? 1,
      wgtScore: (json['wgtScore']) ?? 0.0,
      partRatings:
          (json['partRatings'] as Map<String, dynamic>?)?.map((key, value) {
                return MapEntry(key, value);
              }) ??
              {},
      notes: (json['notes'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'userId': userId,
      'image': image,
      'name': name,
      'address': address,
      'visitDate': visitDate,
      'propertyRating': propertyRating,
      'partRatings': partRatings,
      'wgtScore': wgtScore,
      'notes': notes,
    };
  }
}
