import 'package:flutter/material.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';
import 'package:houszscore/firebase.dart/firebase_services.dart';

class PricingPlanScreen extends StatefulWidget {
  const PricingPlanScreen({Key? key}) : super(key: key);

  @override
  _PricingPlanScreenState createState() => _PricingPlanScreenState();
}

class _PricingPlanScreenState extends State<PricingPlanScreen> {
  String? _selectedPlanId;
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
        _filterPlans(); // Filter plans after fetching
        _isLoading = false;
      });

      print("Fetched Plans: $_allPlans"); // Debugging log
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
              plan['billingCycle'] == (_isAnnual ? 'Per Year' : 'Per Month'))
          .toList();
    });
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
                    _filterPlans(); // Filter plans when toggling
                  });
                }),
                SizedBox(width: 20),
                _buildToggleButton('Annually', _isAnnual, () {
                  setState(() {
                    _isAnnual = true;
                    _filterPlans(); // Filter plans when toggling
                  });
                }),
              ],
            ),
            SizedBox(height: 20),
            Text('Save on annual plans', style: TextStyles.size14Weight500),
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
    required String name,
    required String price,
    required String billingCycle,
    required String description,
    required List<String> benefits,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedPlanId == name ? AppColor.blue : AppColor.btnGrey,
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
                Text(name, style: TextStyles.size14Weight600),
                Checkbox(
                  side: BorderSide(color: AppColor.grey),
                  checkColor: Colors.white,
                  activeColor: AppColor.blue,
                  value: _selectedPlanId == name,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlanId = value == true ? name : null;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('$price USD', style: TextStyles.size20Weight700),
                Text(' $billingCycle',
                    style: TextStyles.size16Weight700
                        .copyWith(color: AppColor.grey)),
              ],
            ),
            SizedBox(
              width: 310,
              child: Text(
                description,
                style: TextStyles.size14Weight500
                    .copyWith(color: Color(0xFF73776A)),
              ),
            ),
            SizedBox(height: 10),
            Text("Benefits:", style: TextStyles.size16Weight600),
            ...benefits.map((benefit) {
              return Row(
                children: [
                  Text("See benefits", style: TextStyles.size16Weight600),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(AppIcon.dwonArrow, scale: 4),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
