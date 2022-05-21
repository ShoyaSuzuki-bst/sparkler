import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid = '';
  String name = '';
  String phoneNumber = '';
  final FirebaseFirestore store = FirebaseFirestore.instance;

  User(
    String uid,
    String name,
    String phoneNumber
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



  User update(String _uid, String _name, String _phoneNumber) {
    return User(
      "sample",
      "sample",
      "sample",
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
}
