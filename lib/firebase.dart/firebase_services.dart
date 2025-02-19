import 'dart:convert';
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

  Future<void> deletePreferences() async {
    if (currentUser == null) return;
    try {
      await _preferencesCollection.doc(currentUser!.uid).delete();
    } catch (e) {
      print("Error deleting preferences: $e");
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

  Future<void> uploadVisitingData(VisitingData data) async {
    if (currentUser == null) return;

    try {
      await _visitingCollection
          .doc("${data.propertyId}")
          .set(data.toJson(), SetOptions(merge: true));
    } catch (e) {
      print("Error uploading visiting data: $e");
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
    return _checkDocumentExists(_favoritesCollection, propertyId);
  }

  //################### Suggestion List Functions ###########################
  Future<DocumentSnapshot> getRecommend(String propertyId) =>
      _propertiesCollection.doc(propertyId).get();

  Stream<List<Map<String, dynamic>>> getRecommendations() =>
      _streamCollection(_propertiesCollection);

  //################### Helper Functions ####################################
  Future<bool> _checkDocumentExists(
      CollectionReference collection, String propertyId) async {
    try {
      final query =
          await collection.where('propertyId', isEqualTo: propertyId).get();
      return query.docs.isNotEmpty;
    } catch (e) {
      print("Error checking document existence: $e");
      return false;
    }
  }

  // Future<void> _uploadDoc(CollectionReference collection, String docId,
  //     Map<String, dynamic> data) async {
  //   try {
  //     await collection.doc(docId).set(data, SetOptions(merge: true));
  //   } catch (e) {
  //     print("Error uploading/updating document: $e");
  //   }
  // }

  Stream<List<Map<String, dynamic>>> _streamCollection(
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
          "name": data["name"] ?? "N/A",
          "price": data["price"] ?? "0",
          "billingCycle": data["billingCycle"] ?? "N/A",
          "frequency": data.containsKey("frequency")
              ? data["frequency"]
              : "Not Available", // ✅ Safe handling
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
}
