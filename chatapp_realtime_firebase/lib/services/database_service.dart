import 'package:chatapp_realtime_firebase/models/user_profile.dart';
import 'package:chatapp_realtime_firebase/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  DatabaseService() {
    _authService = _getIt.get<AuthService>();
    _setupCollectionRefereces();
  }
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;

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

  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _usersCollection?.where('uid', isNotEqualTo: _authService.user!.uid).snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }
}
