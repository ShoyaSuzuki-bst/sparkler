import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class User {
  final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  String uid = '';
  String name = '';
  String phoneNumber = '';

  User(
    this.uid,
    this.name,
    this.phoneNumber
  );

  static User create(String _uid, String _name, String _phoneNumber) {
    FirebaseFirestore.instance.collection('users').doc(_uid).set({
      'name': _name,
      'phoneNumber': _phoneNumber,
    });
    return User(
      _uid,
      _name,
      _phoneNumber,
    );
  }

  static List<User> where() {
    return [];
  }

  static User find(String _uid) {
    return User(
      "sample",
      "sample",
      "sample",
    );
  }

  static User transModelFromAuth(fb.User fbUser) {
    return User(
      fbUser.uid,
      fbUser.displayName!,
      fbUser.phoneNumber!,
    );
  }

  static Future<User> transModelFromRef(DocumentReference<Map<String, dynamic>> ref) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    final Map map = snapshot.data()!;
    return User(
      snapshot.id,
      map['name'],
      map['phoneNumber'],
    );
  }

  static User getCurrentUser() {
    final fb.User fbUser = fb.FirebaseAuth.instance.currentUser!;
    final String uid = fbUser.uid;
    print('uid : $uid');
    final User currentUser = User(
      uid,
      fbUser.displayName!,
      fbUser.phoneNumber!,
    );
    print('currentUser.name: ${currentUser.name}');
    return currentUser;
  }

  static Future<User> refToInst(DocumentReference ref) async {
    final snapshot = await ref.get();
    return User(
      snapshot.id,
      snapshot['name'],
      snapshot['phoneNumber'],
    );
  }

  static Future<bool> exists(String uid) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('collectionName');

      var doc = await collectionRef.doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  User update(String _uid, String _name, String _phoneNumber) {
    return User(
      "sample",
      "sample",
      "sample",
    );
  }

  void logout() async {
    await auth.signOut();
  }

  Future<User> updateDisplayName(String _name) async {
    await auth.currentUser!.updateDisplayName(_name);
    await store.collection('users').doc(uid).update({'name': _name});
    return User(
      uid,
      _name,
      phoneNumber,
    );
  }

  DocumentReference<Map<String, dynamic>> getRef() {
   return store
      .collection('users')
      .doc(uid);
  }
}
