import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparkler/models/topic.dart';
import 'package:sparkler/models/user.dart';

class Message {
  String message = '';
  DateTime createdAt = DateTime(0);
  String userName = '';
  User user = User(
    '',
    '',
    ''
  );
  Topic topic = Topic(
    '',
    '',
    User(
      '',
      '',
      '',
    ),
  );

  Message(
    this.message,
    this.userName,
    this.user,
    this.topic,
  );

  void sendMessage() async {
    final DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid);
    final topicId = topic.id;
    final FirebaseFirestore store = FirebaseFirestore.instance;
    await store
      .collection('topics')
      .doc(topicId)
      .collection('messages')
      .add({
        'message': message,
        'userName': user.name,
        'userReference': userRef,
        'createdAt': DateTime.now(),
      });
  }
}
