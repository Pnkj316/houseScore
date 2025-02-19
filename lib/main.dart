import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:houszscore/BottomNavBar/Provider/userid_provider.dart';
import 'package:houszscore/Login/login_1.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51QrbiYKnDXOGJdEO1r3Tb6aTdwTaaEg04SKjtmJ11xxYxg4JCHtFJhfWDGX1g4K9DcejxvaDjkO01NBB0uolaqfB0070vN1iFH";
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(backgroundColor: Colors.white)),
            color: Colors.white,
            home: Scaffold(backgroundColor: Colors.white, body: Login1Screen()),
          );
        });
  }
}
