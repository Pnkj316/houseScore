class SubscriptionPlan {
  final String name;
  final int price;
  final String billingCycle;
  final String description;
  final List<String> benefits;

  SubscriptionPlan({
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.description,
    required this.benefits,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "billingCycle": billingCycle,
      "description": description,
      "benefits": benefits,
    };
  }

  // Convert Firestore document to SubscriptionPlan object
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      name: json["name"],
      price: json["price"],
      billingCycle: json["billingCycle"],
      description: json["description"],
      benefits: List<String>.from(json["benefits"]),
    );
  }
}
