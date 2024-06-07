import 'package:chatapp_realtime_firebase/pages/login_page.dart';
import 'package:chatapp_realtime_firebase/services/navigation_services.dart';
import 'package:chatapp_realtime_firebase/utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    _navigationServices = _getIt.get<NavigationServices>();
  }
  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationServices.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const LoginPage(),
    );
  }
}
