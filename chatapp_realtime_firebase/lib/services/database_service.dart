import 'dart:js_interop';

import 'package:chatapp_realtime_firebase/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService() {
    _setupCollectionRefereces();
  }
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;

  void _setupCollectionRefereces() {
    _usersCollection = _firebaseFirestore.collection('users').withConverter<UserProfile>(
          fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => UserProfile.fromJson(snapshot.data()!),
          toFirestore: (UserProfile userProfile, _) => userProfile.toJson(),
        );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }
}
