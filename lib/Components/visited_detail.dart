// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:houszscore/Components/pricing_plan_screen.dart';
// import 'package:houszscore/Utils/app_color.dart';
// import 'package:houszscore/Utils/app_icon.dart';
// import 'package:houszscore/Utils/app_img.dart';
// import 'package:houszscore/Utils/text_style.dart';
// import 'package:houszscore/Visit%20Review/visting1_screen.dart';

// class VisitedDetailsScreen extends StatelessWidget {
//   VisitedDetailsScreen({super.key});

//   final List<String> imgList = [
//     AppImage.houseGreen,
//     AppImage.bedroom,
//     AppImage.kitchen,
//     AppImage.garage,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: _buildFloatingVictoria(context),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new_rounded),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text('Details'),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: AppColor.btnGrey),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
//             children: [
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 200.0,
//                   autoPlay: true,
//                   enlargeCenterPage: true,
//                   aspectRatio: 16 / 9,
//                   initialPage: 0,
//                   enableInfiniteScroll: true,
//                   viewportFraction: 1,
//                 ),
//                 items: imgList
//                     .map((item) => Container(
//                           child: Center(
//                             child: Image.asset(item,
//                                 fit: BoxFit.cover, width: 1000),
//                           ),
//                         ))
//                     .toList(),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   buildPropertyDetail(),
//                   SizedBox(height: 16),
//                   buildGreyContainer(context),
//                   _buildGridCount(),
//                   _buildAbout(),
//                   _buildMap(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMap() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Map",
//             style: TextStyles.size16Weight600,
//           ),
//           SizedBox(height: 5),
//           Text(
//             "3104 Western Ave #419, Seattle, WA 98121",
//             style: TextStyles.size14Weight400.copyWith(color: AppColor.grey),
//           ),
//           SizedBox(height: 20),
//           Container(
//             color: Colors.green,
//             width: double.infinity,
//             height: 228,
//             child: Center(child: Text("Hello World!")),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAbout() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "About",
//             style: TextStyles.size16Weight600,
//           ),
//           SizedBox(height: 20),
//           SizedBox(
//             width: double.infinity,
//             child: Text(
//               'Indulge in the pinnacle of luxury living in this stunning home nestled on an almost acre corner lot, boasting breathtaking views of Mt. Diablo. This exquisite property features five spacious bedrooms and four luxurious bathrooms, providing ample space for relaxation and privacy. The gourmet kitchen is a chef’s dream, equipped with top-of-the-line appliances and elegant finishes. High ceilings and large windows fill the home with natural light, enhancing its open and airy ambiance.',
//               style: TextStyles.size16Weight400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildGreyContainer(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
//       width: double.infinity,
//       color: AppColor.lightGrey,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Open house Today, May 30',
//                 style: TextStyles.size16Weight700.copyWith(
//                   color: Color(0xFF2D75FF),
//                 ),
//               ),
//               Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PricingPlanScreen()));
//                 },
//                 child: Row(
//                   children: [
//                     Icon(Icons.watch_later_rounded,
//                         color: Colors.blue, size: 15),
//                     SizedBox(width: 4),
//                     Text(
//                       'BOOK A TOUR',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                         color: Color(0xFF2D75FF),
//                         fontSize: 11,
//                         fontFamily: 'SF Pro',
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           Divider(),
//           SizedBox(height: 5),
//           InkWell(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => Visiting1Screen()));
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'RECORD THE VISIT',
//                   style: TextStyle(
//                     color: Color(0xFF2D75FF),
//                     fontSize: 12,
//                     fontFamily: 'SF Pro',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 Container(
//                   width: 30,
//                   height: 30,
//                   decoration: ShapeDecoration(
//                       shape: OvalBorder(), color: AppColor.blue),
//                   child: Icon(
//                     Icons.camera_alt,
//                     color: Colors.white,
//                     size: 15,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildPropertyDetail() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'The Green House',
//                 style: TextStyles.size20Weight600,
//               ),
//               SizedBox(height: 4),
//               Text(
//                 '3104 Western Ave #419,\nSeattle, WA 98121',
//                 style: TextStyle(
//                   color: Colors.black.withOpacity(0.49),
//                   fontSize: 11,
//                   fontFamily: 'SF Pro',
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//           Image.asset(AppIcon.nintyNine, scale: 1.5),
//         ],
//       ),
//     );
//   }

//   Widget _buildFloatingVictoria(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
//       child: GestureDetector(
//         onTap: () => _showBottomModalSheet(context),
//         child: Container(
//           padding: EdgeInsets.all(2),
//           width: 220,
//           height: 50,
//           decoration: BoxDecoration(
//               color: AppColor.blue,
//               borderRadius: BorderRadius.all(Radius.circular(100))),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 child: Image.asset(AppImage.victoria),
//                 radius: 25,
//               ),
//               SizedBox(width: 9),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'YOUR AGENT',
//                     style: TextStyle(fontSize: 14, color: Colors.white),
//                   ),
//                   Text(
//                     'Victoria Dea',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Spacer(),
//               Image.asset(
//                 AppIcon.message,
//                 scale: 4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGridCount() {
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       childAspectRatio: 3.85,
//       children: [
//         PropertyAttribute(
//           label: 'On HowScore',
//           value: '9 hours',
//         ),
//         PropertyAttribute(
//           label: 'Year Built',
//           value: '1947',
//         ),
//         PropertyAttribute(
//           label: '\$/Sq Ft',
//           value: '\$1,111',
//         ),
//         PropertyAttribute(
//           label: 'Lot Size',
//           value: '0.73 Acres',
//         ),
//         PropertyAttribute(
//           label: 'HOA',
//           value: 'None',
//         ),
//         PropertyAttribute(
//           label: 'Status',
//           value: 'Active',
//         ),
//       ],
//     );
//   }

//   void _showBottomModalSheet(BuildContext context) {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           return DraggableScrollableSheet(
//               initialChildSize: 0.8,
//               maxChildSize: 0.9,
//               minChildSize: 0.4,
//               builder:
//                   (BuildContext context, ScrollController scrollController) {
//                 return Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(25)),
//                     ),
//                     child: ListView(controller: scrollController, children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: AppColor.blue,
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(25)),
//                         ),
//                         child: Column(
//                           children: [
//                             Align(
//                               alignment: Alignment.topRight,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Container(
//                                   margin: EdgeInsets.only(
//                                       top: 10, right: 10, bottom: 10),
//                                   height: 25,
//                                   width: 25,
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(30)),
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.close,
//                                       color: Colors.grey,
//                                       size: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.vertical(
//                                     top: Radius.circular(25)),
//                               ),
//                               child: Stack(
//                                   alignment: Alignment.topCenter,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         SizedBox(height: 10),
//                                         Container(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 40),
//                                           width: 40,
//                                           height: 5,
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey[300],
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                         CircleAvatar(
//                                           radius: 40,
//                                           child: Image.asset(
//                                               'assets/images/victoria.png'), // Update with your image path
//                                         ),
//                                         SizedBox(height: 10),
//                                         Text(
//                                           'Victoria Dea',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 22,
//                                           ),
//                                         ),
//                                         Text(
//                                           'License #7654567',
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                         SizedBox(height: 5),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               '5.0',
//                                               style:
//                                                   TextStyle(color: Colors.grey),
//                                             ),
//                                             Icon(Icons.star,
//                                                 color: Colors.orange, size: 16),
//                                             Icon(Icons.star,
//                                                 color: Colors.orange, size: 16),
//                                             Icon(Icons.star,
//                                                 color: Colors.orange, size: 16),
//                                             Icon(Icons.star,
//                                                 color: Colors.orange, size: 16),
//                                             Icon(Icons.star,
//                                                 color: Colors.orange, size: 16),
//                                             SizedBox(width: 5),
//                                             Text(
//                                               '• 78 reviews',
//                                               style:
//                                                   TextStyle(color: Colors.blue),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: 10),
//                                         Text(
//                                           'email@gmail.com',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         Divider(),
//                                         Text(
//                                           '+1 812 9876 5654',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                       ],
//                                     ),
//                                   ]),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text(
//                           'I am a Bay Area native, born and raised in San Francisco. Later, I moved to the East Bay, where I purchased and sold property. With 15 years of experience in real estate, I have come to understand the complexities of the buying and selling processes and the importance of working with a knowledgeable and effective agent. You can rest assured that I will be your strongest advocate in the purchase of your dream home.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Text(
//                           'Victoria’s Listing Sales',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(children: [
//                             SizedBox(width: 16),
//                             _buildImageCard(AppImage.fav1),
//                             _buildImageCard(AppImage.houseGreen),
//                             _buildImageCard(AppImage.condo),
//                             SizedBox(width: 16)
//                           ])),
//                       SizedBox(height: 20),
//                       Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       showModalBottomSheet(
//                                           context: context,
//                                           isScrollControlled: true,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.vertical(
//                                               top: Radius.circular(25.0),
//                                             ),
//                                           ),
//                                           builder: (context) => Padding(
//                                                 padding: EdgeInsets.only(
//                                                   bottom: MediaQuery.of(context)
//                                                       .viewInsets
//                                                       .bottom,
//                                                 ),
//                                                 child: buildBottomCallSheet(
//                                                     context),
//                                               ));
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColor.blue,
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 45, vertical: 10),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         )),
//                                     child: Row(children: [
//                                       Icon(Icons.call_outlined,
//                                           color: Colors.white, size: 15),
//                                       SizedBox(width: 5),
//                                       Text(
//                                         'Book a call',
//                                         style: TextStyles.size14Weight500
//                                             .copyWith(color: Colors.white),
//                                       )
//                                     ])),
//                                 OutlinedButton(
//                                     onPressed: () {},
//                                     style: OutlinedButton.styleFrom(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 45, vertical: 10),
//                                         shape: RoundedRectangleBorder(
//                                           side: BorderSide(
//                                               color: AppColor.btnGrey),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         )),
//                                     child: Row(children: [
//                                       Icon(Icons.mail_outlined,
//                                           color: Colors.black, size: 15),
//                                       SizedBox(width: 5),
//                                       Text('Contact',
//                                           style: TextStyles.size14Weight500
//                                               .copyWith(color: Colors.black))
//                                     ])),
//                               ])),
//                       SizedBox(height: 20),
//                     ]));
//               });
//         });
//   }

//   Widget _buildImageCard(String imgPath) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 8),
//       width: 150,
//       height: 100,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Image.asset(imgPath),
//     );
//   }

//   Widget buildBottomCallSheet(BuildContext context) {
//     return Container(
//       height: 450,
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ),

//           Text(
//             'Book a call',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 20),
//           // Text fields for Name, Email, and Message
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Name',
//               labelStyle:
//                   TextStyles.size16Weight500.copyWith(color: AppColor.grey),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Email',
//               labelStyle:
//                   TextStyles.size16Weight500.copyWith(color: AppColor.grey),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             maxLines: 3,
//             decoration: InputDecoration(
//               labelText: 'Write a message...',
//               labelStyle:
//                   TextStyles.size16Weight500.copyWith(color: AppColor.grey),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey[100]!),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           // "Get in Touch" button
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black87,
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () {
//               // Handle the "Get in Touch" action
//             },
//             child: Center(
//               child: Text(
//                 'Get in touch',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PropertyAttribute extends StatelessWidget {
//   final String label;
//   final String value;

//   const PropertyAttribute({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
//       child: SizedBox(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: Color(0xFF9A9A9A),
//                     fontSize: 12,
//                     fontFamily: 'SF Pro',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   value,
//                   textAlign: TextAlign.right,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     fontFamily: 'SF Pro',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//             Divider(),
//           ],
//         ),
//       ),
//     );
//   }
// }
