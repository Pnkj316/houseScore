import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:houszscore/BottomNavBar/Provider/userid_provider.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  Future<String> _getPlanName(int planId) async {
    if (planId == 0) return "Unknown Plan";

    try {
      print("Fetching plan name for Plan ID: $planId");

      QuerySnapshot querySnapshot = await _firebaseService
          .subscriptionCollection
          .where('planId', isEqualTo: planId)
          .limit(1)
          .get();

      print("Documents found: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print("Plan Data: $data");
        return data['name'] ?? "Unknown Plan";
      }
    } catch (e) {
      print("Error fetching plan name: $e");
    }

    return "Unknown Plan";
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    return Scaffold(
      appBar: AppBar(title: Text("My Subscribed Plans")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getUserSubscriptionsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No subscribed plans found."));
          }

          List<Map<String, dynamic>> plans = snapshot.data!;

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              var planData = plans[index];
              int planId = (planData['planId'] ?? 0);

              return FutureBuilder<String>(
                future: _getPlanName(planId),
                builder: (context, planSnapshot) {
                  String planName =
                      planSnapshot.connectionState == ConnectionState.waiting
                          ? "Loading..."
                          : planSnapshot.data ?? "Unknown Plan";

                  String formattedDate = "N/A";
                  if (planData['expiryDate'] != null) {
                    Timestamp expiryTimestamp = planData['expiryDate'];
                    DateTime expiryDate = expiryTimestamp.toDate();
                    formattedDate =
                        DateFormat('dd MMM yyyy').format(expiryDate);
                  }

                  return Card(
                    color: Colors.white70,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(planName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Expires on: $formattedDate"),
                      trailing: planData['isSubscribed'] == true
                          ? ElevatedButton(
                              onPressed: () => _firebaseService
                                  .deactivateSubscription(userId),
                              child: Text("Deactivate",
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                            )
                          : Text("Inactive",
                              style: TextStyle(color: Colors.grey)),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
