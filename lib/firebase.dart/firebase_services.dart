import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:houszscore/Components/pricing_plan_screen.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:houszscore/modal/visting_modal.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  final CollectionReference _favoritesCollection =
      FirebaseFirestore.instance.collection('favourites');
  final CollectionReference _propertiesCollection =
      FirebaseFirestore.instance.collection('properties');
  final CollectionReference _visitingCollection =
      FirebaseFirestore.instance.collection('visitingData');
  final CollectionReference _preferencesCollection =
      FirebaseFirestore.instance.collection('preferences');
  final CollectionReference _agentsCollection =
      FirebaseFirestore.instance.collection('property_agents');
  final CollectionReference _subscriptionCollection =
      FirebaseFirestore.instance.collection('subscription_plans');

  final CollectionReference _subscribedCollection =
      FirebaseFirestore.instance.collection('subscribed_users');

  //################### Agent Functions ######################################
  Future<List<Map<String, dynamic>>> getAgentData(String agentId) async {
    try {
      final doc = await _agentsCollection.doc(agentId).get();
      if (doc.exists)
        return [
          {'id': doc.id, ...doc.data() as Map<String, dynamic>}
        ];
    } catch (e) {
      print("Error fetching agent data: $e");
    }
    return [];
  }

  //################### Preference Functions #################################
  Future<void> savePreference(Map<String, dynamic> data) async {
    if (currentUser == null) return;
    try {
      await _preferencesCollection.doc(currentUser!.uid).set({
        'prefs': data,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving preference: $e");
    }
  }

  Future<Map<String, dynamic>?> getPreferences() async {
    if (currentUser == null) return null;
    try {
      final doc = await _preferencesCollection.doc(currentUser!.uid).get();
      return doc.exists ? doc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      print("Error retrieving preferences: $e");
      return null;
    }
  }

  Future<void> updatePreference(String screenKey, dynamic value) async {
    if (currentUser == null) return;
    try {
      var userDoc = await _preferencesCollection.doc(currentUser!.uid).get();

      if (userDoc.exists) {
        await _preferencesCollection.doc(currentUser!.uid).update({
          'prefs.$screenKey': value,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Preference updated: $screenKey -> $value");
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      print("Error updating preference for $screenKey: $e");
      throw Exception("Failed to update preference");
    }
  }

  Future<void> updateAllPreferences(Map<String, dynamic> preferences) async {
    if (currentUser == null) return;
    try {
      await _preferencesCollection.doc(currentUser!.uid).update({
        'prefs': preferences,
      });
      print("All preferences updated successfully.");
    } catch (e) {
      print("Error updating all preferences: $e");
      throw Exception("Failed to update all preferences");
    }
  }

  //################### Visiting Functions ###################################
  Future<bool> isPropertyVisited(String propertyId) async {
    if (currentUser == null) return false;

    try {
      final query = await _visitingCollection
          .where('propertyId', isEqualTo: propertyId)
          .where('userId', isEqualTo: currentUser!.uid)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if property is visited: $e");
      return false;
    }
  }

  Future<double> getPropertyScore(String propertyId) async {
    if (currentUser == null) return 0.0;

    try {
      final doc = await _visitingCollection.doc(propertyId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          if (data.containsKey('userId') &&
              data['userId'] == currentUser!.uid) {
            return (data['wgtScore'] as num?)?.toDouble() ?? 0.0;
          }
        }
      }
    } catch (e) {
      print("Error fetching property score: $e");
    }

    return 0.0;
  }

  Future<bool> uploadVisitingData(
      VisitingData data, BuildContext context) async {
    if (currentUser == null) return false;

    try {
      // Step 1: Fetch user's plan limit
      Map<String, dynamic> subsData = await getUserPlanLimit();
      int allowedVisits = subsData['allowedVisits'] ?? 0;

      String subscriptionId = subsData['subscriptionId'] ?? '';

      int visitedCount = await getVisitedPropertiesCount();

      print("Visited Properties Count: $visitedCount");
      print("Allowed Visits: $allowedVisits");
      print("Subscription ID: $subscriptionId");

      // Step 2: Check if user has reached the visit limit
      if (visitedCount >= allowedVisits) {
        print("User has reached the maximum allowed property visits.");

        // Show pop-up
        _showLimitReachedDialog(context);
        return false; // Deny further visits
      }

      // Step 3: Add subscriptionId to data
      Map<String, dynamic> visitingDataJson = data.toJson();
      visitingDataJson['subscriptionId'] = subscriptionId;

      // Step 4: Proceed to upload the visit data
      await _visitingCollection
          .doc(data.propertyId) // Use property ID as the document ID
          .set(visitingDataJson, SetOptions(merge: true));

      print("Visiting data uploaded successfully.");
      return true;
    } catch (e) {
      print("Error uploading visiting data: $e");
      return false;
    }
  }

  Future<void> updateVisitingData(String propertyId, VisitingData data) async {
    try {
      await _visitingCollection.doc(propertyId).update(data.toJson());
    } catch (e) {
      print("Error updating visiting data: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getVisits() =>
      _streamCollection(_visitingCollection);

  //################### Favorite Functions ###################################
  Future<void> toggleFavorite(
      String propertyId, Map<String, dynamic> propertyData) async {
    if (currentUser == null) return;
    propertyData['userId'] = currentUser!.uid;

    final docRef = _favoritesCollection.doc(propertyId);
    final docSnapshot = await docRef.get();

    try {
      docSnapshot.exists
          ? await docRef.delete()
          : await docRef.set(propertyData);
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  Stream<bool> isFavoriteStream(String propertyId) =>
      _favoritesCollection.doc(propertyId).snapshots().map((doc) => doc.exists);

  Stream<List<Map<String, dynamic>>> getFavorites() =>
      _streamCollection(_favoritesCollection);

  Future<bool> isFavorite(String propertyId) async {
    if (currentUser == null) return false;

    try {
      final query = await _favoritesCollection
          .where('propertyId', isEqualTo: propertyId)
          .where('userId', isEqualTo: currentUser!.uid)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if property is visited: $e");
      return false;
    }
  }

  //################### Suggestion List Functions ###########################
  Future<DocumentSnapshot> getRecommend(String propertyId) =>
      _propertiesCollection.doc(propertyId).get();

  Stream<List<Map<String, dynamic>>> getRecommendations() =>
      _allStreamCollection(_propertiesCollection);

  Stream<List<Map<String, dynamic>>> _streamCollection(
      CollectionReference collection) {
    return collection.snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc['userId'] == currentUser!.uid)
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> _allStreamCollection(
      CollectionReference collection) {
    return collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    });
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      print("User logged out successfully.");
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  /// Fetch subscription plans from Firestore
  Future<List<Map<String, dynamic>>> getSubscriptionPlans() async {
    try {
      QuerySnapshot querySnapshot = await _subscriptionCollection.get();

      List<Map<String, dynamic>> plans = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return {
          "planId": data['planId'] ?? "0",
          "name": data["name"] ?? "N/A",
          "price": data["price"] ?? "0",
          "duration": data["duration"] ?? "0",
          "prop": data["prop"] ?? "0",
          "billingCycle": data["billingCycle"] ?? "N/A",
          "description": data["description"] ?? "No description available",
          "benefits":
              (data["benefits"] as List<dynamic>?)?.cast<String>() ?? [],
        };
      }).toList();

      return plans;
    } catch (e) {
      print("Error fetching subscription plans: $e");
      return [];
    }
  }

  //#################################Payment Method ###########################

  Future<String> createPaymentIntent(double amount) async {
    final response = await http.post(
      Uri.parse('https://housescore-stripe.vercel.app/create-payment-intent'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json', // Specify the content type
      },
      body: jsonEncode({
        // Ensure the body is in JSON format
        'amount': amount * 100, // Amount in cents
        'currency': 'usd'
      }),
    );
    var data = jsonDecode(response.body);
    return data['clientSecret'];
  }

  //##################### users functions #####################################

  Future<bool> subscriptionStatus({
    required bool isSubscribed,
    required int durationInDays,
    required int planId,
    required int allowedVisit,
    required String transactionId,
  }) async {
    try {
      // Generate a new document reference with an auto-generated ID
      final docRef = _subscribedCollection.doc();
      final String subscriptionId = docRef.id; // Get the generated document ID

      // Calculate dates
      DateTime expiryDate = DateTime.now().add(Duration(days: durationInDays));
      DateTime now = DateTime.now();

      // Create subscription data
      Map<String, dynamic> subscriptionData = {
        'subscriptionId': subscriptionId,
        'isSubscribed': isSubscribed,
        'expiryDate': Timestamp.fromDate(expiryDate),
        'startDate': Timestamp.fromDate(now),
        'planId': planId,
        'allowedVisit': allowedVisit,
        'userId': currentUser!.uid,
        'duration': durationInDays,
        'transactionId': transactionId,
      };

      // Store subscription data directly in Firestore
      await docRef.set(subscriptionData);

      print("User subscription status updated successfully.");
      return true;
    } catch (e) {
      print("Error updating subscription status: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserPlanLimit() async {
    if (currentUser == null) return {"allowedVisits": 0, "subscriptionId": ""};

    try {
      // Fetch user's active subscription documents
      final userSubscriptionsSnapshot = await _subscribedCollection
          .where('userId', isEqualTo: currentUser!.uid)
          // .orderBy('expiryDate', descending: true) // Sorting requires an index
          .get();

      if (userSubscriptionsSnapshot.docs.isEmpty) {
        return {"allowedVisits": 0, "subscriptionId": ""};
      }

      // Filter active subscriptions
      DateTime now = DateTime.now();
      final activeSubscriptions = userSubscriptionsSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return (data['expiryDate'] as Timestamp).toDate().isAfter(now);
      }).toList();

      if (activeSubscriptions.isEmpty) {
        return {"allowedVisits": 0, "subscriptionId": ""};
      }

      // Get latest active subscription's allowed visits and subscription ID
      final data = activeSubscriptions.first.data() as Map<String, dynamic>;
      final int allowedVisits = (data['allowedVisit'] as num?)?.toInt() ?? 0;
      final String subscriptionId = data['subscriptionId'] as String? ?? "";

      print("Allowed Visits: $allowedVisits, Subscription ID: $subscriptionId");

      return {"allowedVisits": allowedVisits, "subscriptionId": subscriptionId};
    } catch (e) {
      if (e.toString().contains("failed-precondition")) {
        print(
            "Firestore requires an index for this query. Create it here: https://console.firebase.google.com/v1/r/project/YOUR_PROJECT_ID/firestore/indexes");
      } else {
        print("Error fetching allowed visits: $e");
      }
      return {"allowedVisits": 0, "subscriptionId": ""};
    }
  }

  Future<List<Map<String, dynamic>>> getVisitedProperties() async {
    if (currentUser == null) return [];

    try {
      final visitSnapshot = await _visitingCollection
          .where('userId', isEqualTo: currentUser!.uid)
          .get();

      return visitSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print("Error fetching visited properties: $e");
      return [];
    }
  }

  Future<int> getVisitedPropertiesCount() async {
    if (currentUser == null) return 0;

    try {
      // Fetch user's active subscription
      final subsData = await getUserPlanLimit();
      String subscriptionId = subsData['subscriptionId'];

      if (subscriptionId.isEmpty) {
        print("No active subscription found.");
        return 0; // Return 0 instead of []
      }

      // Fetch visited properties matching the userId and subscriptionId
      final visitSnapshot = await _visitingCollection
          .where('userId', isEqualTo: currentUser!.uid)
          .where('subscriptionId', isEqualTo: subscriptionId)
          .get();

      return visitSnapshot.size; // Directly return the count
    } catch (e) {
      print("Error fetching visited properties count: $e");
      return 0; // Return 0 in case of an error
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserPlan() async {
    if (currentUser == null) return null;

    try {
      final subsSnapshot = await _subscriptionCollection
          .where('userId', isEqualTo: currentUser!.uid)
          .where('isSubscribed', isEqualTo: true)
          .orderBy('expiryDate', descending: true)
          .limit(1)
          .get();

      if (subsSnapshot.docs.isEmpty) {
        print("No active subscription found.");
        return null;
      }

      // Extracting the first document (latest valid subscription)
      Map<String, dynamic> currentPlan = {
        'id': subsSnapshot.docs.first.id,
        ...subsSnapshot.docs.first.data() as Map<String, dynamic>
      };

      return currentPlan;
    } catch (e) {
      print("Error fetching current user plan: $e");
      return null;
    }
  }

  void _showLimitReachedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Limit Reached"),
        content: Text(
            "You have reached your property visit limit. Please upgrade your plan to continue."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PricingPlanScreen()),
              );
            },
            child: Text("Upgrade Plan"),
          ),
        ],
      ),
    );
  }
}
