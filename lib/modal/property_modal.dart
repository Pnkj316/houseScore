import 'dart:convert';

class PropertyModal {
  final String propertyAgent;
  final String propertyId;
  final String name;
  final String address;
  final String openHouse;
  final String pricePerSqFt;
  final String yearBuilt;
  final String lotSize;
  final String hoa;
  final String status;
  final int score;
  final String image;
  final bool favorite;
  final bool visited;
  final bool recommended;

  PropertyModal({
    required this.propertyId,
    required this.name,
    required this.address,
    required this.openHouse,
    required this.pricePerSqFt,
    required this.yearBuilt,
    required this.lotSize,
    required this.hoa,
    required this.status,
    required this.score,
    required this.image,
    required this.favorite,
    required this.visited,
    required this.propertyAgent,
    required this.recommended,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'propertyAgent': propertyAgent,
      'propertyId': propertyId,
      'name': name,
      'address': address,
      'openHouse': openHouse,
      'pricePerSqFt': pricePerSqFt,
      'yearBuilt': yearBuilt,
      'lotSize': lotSize,
      'hoa': hoa,
      'status': status,
      'score': score,
      'image': image,
      'favorite': favorite,
      'visited': visited,
      'recommended': recommended,
    };
  }

  factory PropertyModal.fromMap(Map<String, dynamic> map) {
    return PropertyModal(
      propertyAgent: map['propertyAgent'] as String,
      propertyId: map['propertyId'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      openHouse: map['openHouse'] as String,
      pricePerSqFt: map['pricePerSqFt'] as String,
      yearBuilt: map['yearBuilt'] as String,
      lotSize: map['lotSize'] as String,
      hoa: map['hoa'] as String,
      status: map['status'] as String,
      score: map['score'] as int,
      image: map['image'] as String,
      favorite: map['favorite'] as bool,
      visited: map['visited'] as bool,
      recommended: map['recommended'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyModal.fromJson(String source) =>
      PropertyModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PropertyModal(propertyAgent: $propertyAgent ,propertyId: $propertyId, name: $name, address: $address, openHouse: $openHouse, pricePerSqFt: $pricePerSqFt, yearBuilt: $yearBuilt, lotSize: $lotSize, hoa: $hoa, status: $status, score: $score, image: $image, favorite: $favorite, visited: $visited, recommended: $recommended)';
  }
}
