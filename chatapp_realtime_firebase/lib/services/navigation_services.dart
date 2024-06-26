import 'package:chatapp_realtime_firebase/pages/home_page.dart';
import 'package:chatapp_realtime_firebase/pages/login_page.dart';
import 'package:chatapp_realtime_firebase/pages/register_page.dart';
import 'package:flutter/material.dart';

class NavigationServices {
  NavigationServices() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }
  late GlobalKey<NavigatorState> _navigatorKey;

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  final Map<String, Widget Function(BuildContext)> _routes = <String, Widget Function(BuildContext p1)>{
    '/login': (BuildContext context) => const LoginPage(),
    '/register': (BuildContext context) => const RegisterPage(),
    '/home': (BuildContext context) => const HomePage(),
  };
  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  void push(MaterialPageRoute route) {
    _navigatorKey.currentState?.push(route);
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
