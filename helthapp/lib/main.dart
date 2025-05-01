import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helthapp/frontend/screens/admin/admin/adminPage.dart';
import 'package:helthapp/frontend/auth/loginPage.dart';
import 'package:helthapp/frontend/screens/homepage/addcart/AddCardScreen.dart';
import 'package:helthapp/frontend/screens/homepage/AppointmentPage.dart';
import 'package:helthapp/frontend/screens/homepage/DoctorDetailPage.dart';
import 'package:helthapp/frontend/screens/homepage/PaymentPage.dart';
import 'package:helthapp/frontend/screens/homepage/homePage.dart';
import 'package:helthapp/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
