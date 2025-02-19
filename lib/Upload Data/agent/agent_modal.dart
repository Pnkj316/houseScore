class Agent {
  final String agentId;
  final String name;
  final String imageUrl;
  final String licenseNumber;
  final double rating;
  final String email;
  final String phone;
  final List<String> propertyIds;

  Agent({
    required this.agentId,
    required this.name,
    required this.imageUrl,
    required this.licenseNumber,
    required this.rating,
    required this.email,
    required this.phone,
    required this.propertyIds,
  });

  // Convert Agent object to Map
  Map<String, dynamic> toMap() {
    return {
      'agentId': agentId,
      'name': name,
      'imageUrl': imageUrl,
      'licenseNumber': licenseNumber,
      'rating': rating,
      'email': email,
      'phone': phone,
      'propertyIds': propertyIds,
    };
  }

  // Create Agent object from Map
  factory Agent.fromMap(Map<String, dynamic> map) {
    return Agent(
      agentId: map['agentId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      propertyIds: List<String>.from(map['propertyIds'] ?? []),
    );
  }
}
