import 'package:chatapp_realtime_firebase/models/chat.dart';
import 'package:chatapp_realtime_firebase/models/message.dart';
import 'package:chatapp_realtime_firebase/models/user_profile.dart';
import 'package:chatapp_realtime_firebase/services/auth_service.dart';
import 'package:chatapp_realtime_firebase/utils.dart';
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
  CollectionReference? _chatsCollection;

  void _setupCollectionRefereces() {
    _usersCollection = _firebaseFirestore.collection('users').withConverter<UserProfile>(
          fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => UserProfile.fromJson(snapshot.data()!),
          toFirestore: (UserProfile userProfile, _) => userProfile.toJson(),
        );
    _chatsCollection = _firebaseFirestore.collection('chats').withConverter<Chat>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => Chat.fromJson(snapshot.data()!),
        toFirestore: (Chat chat, _) => chat.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _usersCollection?.where('uid', isNotEqualTo: _authService.user!.uid).snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final DocumentSnapshot<Object?>? result = await _chatsCollection?.doc(chatID).get();
    print(result);
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final DocumentReference<Object?> docRef = _chatsCollection!.doc(chatID);
    final Chat chat = Chat(id: chatID, participants: <String>[uid1, uid2], messages: <Message>[]);
    await docRef.set(chat);
  }
}
