import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';

class PricingPlanScreen extends StatefulWidget {
  const PricingPlanScreen({Key? key}) : super(key: key);

  @override
  _PricingPlanScreenState createState() => _PricingPlanScreenState();
}

class _PricingPlanScreenState extends State<PricingPlanScreen> {
  int? _selectedPlanId;
  List<Map<String, dynamic>> _allPlans = [];
  List<Map<String, dynamic>> _filteredPlans = [];
  bool _isLoading = true;
  bool _isAnnual = false;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionPlans();
  }

  Future<void> _fetchSubscriptionPlans() async {
    try {
      FirebaseService firebaseServices = FirebaseService();
      List<Map<String, dynamic>> plans =
          await firebaseServices.getSubscriptionPlans();

      setState(() {
        _allPlans = plans;
        _filterPlans();
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching subscription plans: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterPlans() {
    setState(() {
      _filteredPlans = _allPlans
          .where((plan) =>
              (_isAnnual && plan['billingCycle'] == 'Annually') ||
              (!_isAnnual && plan['billingCycle'] == 'Monthly'))
          .toList();
    });
  }

  Future<void> _handlePayment(double amount) async {
    setState(() {
      _isLoading = true;
    });

    try {
      FirebaseService firebaseServices = FirebaseService();
      String clientSecret = await firebaseServices.createPaymentIntent(amount);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Houszscore",
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      var paymentResponse =
          await Stripe.instance.retrievePaymentIntent(clientSecret);
      print("Payment Response: $paymentResponse");

      String transactionId = paymentResponse.id;

      if (transactionId.isEmpty) {
        throw Exception("Transaction ID not found!");
      }

      final selectedPlan = _filteredPlans.firstWhere(
        (plan) => plan['planId'] == _selectedPlanId,
        orElse: () => {},
      );

      if (selectedPlan.isEmpty) {
        print("Error: No plan found for ID $_selectedPlanId");
        return;
      }

      int duration = selectedPlan['duration'] ?? 0;
      int planId = selectedPlan['planId'] ?? 0;
      int allowedVisit = selectedPlan['prop'] ?? 0;
      bool isSubscribed = true;
      await firebaseServices.subscriptionStatus(
        allowedVisit: allowedVisit,
        transactionId: transactionId,
        planId: planId,
        isSubscribed: isSubscribed,
        durationInDays: duration,
      );

      Navigator.pop(context);
      _showAlertDialog("Success", "Your payment was successful!");
    } on StripeException catch (e) {
      print("StripeException: ${e.error.localizedMessage}");
      _showAlertDialog(
          "Payment Error", e.error.localizedMessage ?? "Unknown error");
    } catch (e) {
      print("General error during payment: $e");
      _showAlertDialog("Error", "Something went wrong with the payment.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyles.size14Weight500.copyWith(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Pick Your Plan', style: TextStyles.size20Weight600),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildToggleButton('Monthly', !_isAnnual, () {
                  setState(() {
                    _isAnnual = false;
                    _filterPlans();
                  });
                }),
                SizedBox(width: 20),
                _buildToggleButton('Annually', _isAnnual, () {
                  setState(() {
                    _isAnnual = true;
                    _filterPlans();
                  });
                }),
              ],
            ),
            SizedBox(height: 20),
            Text('Save on annual plans',
                style:
                    TextStyles.size16Weight400.copyWith(color: AppColor.grey)),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.black))
                : Expanded(
                    child: _filteredPlans.isEmpty
                        ? Center(
                            child: Text("No plans available",
                                style: TextStyles.size16Weight600))
                        : ListView.builder(
                            itemCount: _filteredPlans.length,
                            itemBuilder: (context, index) {
                              var plan = _filteredPlans[index];
                              return _buildPlanCard(
                                planId: plan["planId"] ?? '',
                                name: plan['name'] ?? '',
                                price: plan['price'] ?? '',
                                billingCycle: plan['billingCycle'] ?? '',
                                description: plan['description'] ?? '',
                                benefits:
                                    plan['benefits'] as List<String>? ?? [],
                              );
                            },
                          ),
                  ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading || _selectedPlanId == null
                        ? null
                        : () {
                            final selectedPlan = _filteredPlans.firstWhere(
                              (plan) => plan['planId'] == _selectedPlanId,
                              orElse: () => <String, dynamic>{'price': 0.0},
                            );
                            double amount =
                                (selectedPlan['price'] as num?)?.toDouble() ??
                                    0.0;

                            if (amount >= 0.5) {
                              _handlePayment(amount);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Amount must be at least \$0.50 for USD.')),
                              );
                            }
                          },
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Subscribe',
                            style: TextStyles.size16Weight600,
                          ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isSelected, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.black : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        side: BorderSide(color: Colors.grey[300]!),
      ),
      onPressed: onTap,
      child: Text(title),
    );
  }

  Widget _buildPlanCard({
    required int planId,
    required String name,
    required int price,
    required String billingCycle,
    required String description,
    required List<String> benefits,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedPlanId == planId ? AppColor.blue : AppColor.btnGrey,
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: TextStyles.size20Weight700),
                Checkbox(
                  side: BorderSide(color: AppColor.grey),
                  checkColor: Colors.white,
                  activeColor: AppColor.blue,
                  value: _selectedPlanId == planId,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlanId = value == true ? planId : null;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('\$$price USD', style: TextStyles.size20Weight500),
                Text(' $billingCycle',
                    style: TextStyles.size18Weight600
                        .copyWith(color: AppColor.grey)),
              ],
            ),
            SizedBox(height: 5),
            Text(description,
                style:
                    TextStyles.size14Weight500.copyWith(color: AppColor.grey)),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'See Benefits',
                  style: TextStyles.size18Weight700,
                ),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  items: benefits.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                  underline: SizedBox(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
