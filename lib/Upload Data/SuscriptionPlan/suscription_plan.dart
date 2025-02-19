import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houszscore/Upload%20Data/SuscriptionPlan/suscription_modal.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **Uploads subscription plans to Firestore**
  Future<void> saveSubscriptionPlans(VoidCallback onComplete) async {
    List<SubscriptionPlan> plans = [
      SubscriptionPlan(
        name: "Browser",
        price: 100,
        billingCycle: "Monthly",
        description: "A place for small groups to plan & get organized.",
        benefits: ["Feature 1", "Feature 2", "Feature 3"],
      ),
      SubscriptionPlan(
        name: "Seeker",
        price: 150,
        billingCycle: "Monthly",
        description: "For companies using Notion to connect teams & tools.",
        benefits: ["Feature A", "Feature B", "Feature C"],
      ),
      SubscriptionPlan(
        name: "Enterpriser",
        price: 200,
        billingCycle: "Monthly",
        description: "Advanced controls & support to run your organization.",
        benefits: ["Advanced Feature X", "Advanced Feature Y"],
      ),
      SubscriptionPlan(
        name: "Browser",
        price: 1000,
        billingCycle: "Annually",
        description: "A place for small groups to plan & get organized.",
        benefits: ["Feature 1", "Feature 2", "Feature 3"],
      ),
      SubscriptionPlan(
        name: "Seeker",
        price: 1500,
        billingCycle: "Annually",
        description: "For companies using Notion to connect teams & tools.",
        benefits: ["Feature A", "Feature B", "Feature C"],
      ),
      SubscriptionPlan(
        name: "Enterpriser",
        price: 2000,
        billingCycle: "Annually",
        description: "Advanced controls & support to run your organization.",
        benefits: ["Advanced Feature X", "Advanced Feature Y"],
      ),
    ];

    try {
      for (var plan in plans) {
        await _firestore.collection("subscription_plans").add(plan.toJson());
        print("✅ Uploaded: ${plan.name}");
      }
      onComplete(); // Notify UI that upload is complete
    } catch (e) {
      print("❌ Error: $e");
    }
  }
}

class MyApp extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadScreen(firebaseService: firebaseService),
    );
  }
}

class UploadScreen extends StatefulWidget {
  final FirebaseService firebaseService;
  UploadScreen({required this.firebaseService});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isUploading = false;

  void _uploadPlans() {
    setState(() => _isUploading = true);

    widget.firebaseService.saveSubscriptionPlans(() {
      setState(() => _isUploading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Subscription Plans Uploaded Successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Plans")),
      body: Center(
        child: _isUploading
            ? CircularProgressIndicator() // Show loading indicator
            : ElevatedButton(
                onPressed: _uploadPlans,
                child: Text("Upload Subscription Plans"),
              ),
      ),
    );
  }
}
