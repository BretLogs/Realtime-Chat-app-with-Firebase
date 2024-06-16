import 'package:chatapp_realtime_firebase/models/user_profile.dart';
import 'package:chatapp_realtime_firebase/pages/chat_page.dart';
import 'package:chatapp_realtime_firebase/services/alert_service.dart';
import 'package:chatapp_realtime_firebase/services/auth_service.dart';
import 'package:chatapp_realtime_firebase/services/database_service.dart';
import 'package:chatapp_realtime_firebase/services/navigation_services.dart';
import 'package:chatapp_realtime_firebase/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
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
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      child: _chatsList(),
    ));
  }

  Widget _chatsList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfiles(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<UserProfile>> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Unable to load Data'));
        }
        if (snapshot.hasData && snapshot.data != null) {
          final List<QueryDocumentSnapshot<UserProfile>> users = snapshot.data!.docs;
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                UserProfile user = users[index].data();
                return ChatTile(
                    userProfile: user,
                    onTap: () async {
                      final bool chatExists = await _databaseService.checkChatExists(_authService.user!.uid, user.uid!);
                      print(chatExists);
                      if (!chatExists) {
                        await _databaseService.createNewChat(_authService.user!.uid, user.uid!);
                      }
                      _navigationServices.push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return ChatPage(chatUser: user);
                        }),
                      );
                    });
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
