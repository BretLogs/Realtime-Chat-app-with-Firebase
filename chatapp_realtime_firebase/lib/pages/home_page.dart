import 'package:chatapp_realtime_firebase/services/alert_service.dart';
import 'package:chatapp_realtime_firebase/services/auth_service.dart';
import 'package:chatapp_realtime_firebase/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationServices _navigationServices;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _alertService.showToast(text: 'Successfully logged out!', icon: Icons.check);
                _navigationServices.pushReplacementNamed('/login');
              }
            },
            icon: const Icon(Icons.logout),
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
