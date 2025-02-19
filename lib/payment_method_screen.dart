import 'package:flutter/material.dart';
import 'package:houszscore/add_card_details.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class PaymentMethodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment methods',
              style: TextStyles.size22Weight600,
            ),
            SizedBox(height: 10),
            Text(
              'Add and manage your payment methods using our secure payment system.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  _buildPaymentMethod(
                    context,
                    'Visa ... 6965',
                    'Expiry: 11/2028',
                    AppIcon.visa,
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  _buildPaymentMethod(
                    context,
                    'Visa ... 5412',
                    'Expiry: 11/2032',
                    AppIcon.master,
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _showPaymentModalSheet(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Text(
                          'Add payment method',
                          style: TextStyles.size18Weight600
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context, String cardName,
      String expiryDate, String logoPath) {
    return Row(
      children: [
        Image.asset(
          logoPath,
          width: 50,
          height: 50,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              expiryDate,
              style: TextStyles.size14Weight500.copyWith(color: Colors.grey),
            ),
          ],
        ),
        Spacer(),
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.btnGrey),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Text(
              'Edit',
              textAlign: TextAlign.center,
              style: TextStyles.size14Weight600,
            ),
          ),
        ),
      ],
    );
  }

  void _showPaymentModalSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Pay with', style: TextStyles.size22Weight600),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildPaymentOption(
                context,
                'PayPal',
                AppIcon.paypal,
                () {},
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              _buildPaymentOption(
                context,
                'Credit or debit card',
                AppIcon.card,
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCardDetails()));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(BuildContext context, String paymentMethod,
      String logoPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            logoPath,
            width: 30,
            height: 30,
          ),
          SizedBox(width: 16),
          Text(paymentMethod, style: TextStyles.size16Weight400),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }
}
