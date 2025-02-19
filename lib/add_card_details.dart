import 'package:flutter/material.dart';
import 'package:houszscore/Utils/app_color.dart';
import 'package:houszscore/Utils/app_icon.dart';
import 'package:houszscore/Utils/text_style.dart';

class AddCardDetails extends StatelessWidget {
  const AddCardDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(
          "Add card details",
          style: TextStyles.size20Weight600,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompanyLogos(),
            SizedBox(height: 20),
            _buildCardDetails(),
            SizedBox(height: 20),
            _buildPostalCode(),
            SizedBox(height: 20),
            _buildCountry(),
            SizedBox(height: 20),
            _buildActionButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyLogos() {
    return Row(
      children: [
        Image.asset(AppIcon.visa, scale: 3.5),
        SizedBox(width: 20),
        Image.asset(AppIcon.american, scale: 3.5),
        SizedBox(width: 20),
        Image.asset(AppIcon.master, scale: 3.5),
        SizedBox(width: 20),
        Image.asset(AppIcon.discover, scale: 3.5)
      ],
    );
  }

  Widget _buildCardDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: AppColor.lightGrey)),
      width: double.infinity,
      height: 150,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card number",
                      style: TextStyles.size14Weight400
                          .copyWith(color: AppColor.grey),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 2),
                        hintText: "0000 0000 0000",
                        hintStyle: TextStyles.size16Weight400
                            .copyWith(color: AppColor.lightGrey),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              Image.asset(AppIcon.card, color: AppColor.grey, scale: 3.8)
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expiration",
                      style: TextStyles.size14Weight400
                          .copyWith(color: AppColor.grey),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 2),
                        hintText: "MM/YY",
                        hintStyle: TextStyles.size16Weight400
                            .copyWith(color: AppColor.lightGrey),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CVV",
                      style: TextStyles.size14Weight400
                          .copyWith(color: AppColor.grey),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 2, top: 0),
                        hintText: "123",
                        hintStyle: TextStyles.size16Weight400
                            .copyWith(color: AppColor.lightGrey),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPostalCode() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Postcode',
        labelStyle: TextStyles.size16Weight400.copyWith(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCountry() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Country/region',
        hintText: 'United States',
        labelStyle: TextStyles.size16Weight400.copyWith(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('cancel',
              style: TextStyles.size14Weight600.copyWith(color: Colors.black)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColor.lightGrey),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _showPaymentModalSheet(context);
          },
          child: Text('Done',
              style: TextStyles.size14Weight600.copyWith(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
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
                  Text('Edit Visa ...6965', style: TextStyles.size22Weight600),
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
                'Set Default',
                AppIcon.defalt,
                () {},
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              _buildPaymentOption(
                context,
                'Remove',
                AppIcon.remove,
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
          Text(
            paymentMethod,
            style: TextStyles.size16Weight400,
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }
}
