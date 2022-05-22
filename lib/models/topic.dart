import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'message.dart';

class Topic {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  String id = '';
  String title = '';
  User user = User(
    '',
    '',
    '',
  );
  DateTime createdAt = DateTime(0);

  Topic(
    this.id,
    this.title,
    this.createdAt,
    this.user,
  );

  static Future<Topic> create(String title, String firstMessageContent) async {
    final User currentUser = User.getCurrentUser();
    final DocumentReference<Map<String, dynamic>> currentUserRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid);
    final DocumentReference<Map<String, dynamic>> topicRef = await FirebaseFirestore.instance
      .collection('topics')
      .add({
        'title': title,
        'userReference': currentUserRef,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    final topicData = await topicRef.get();
    final snapshot = await topicRef.get();
    final Topic topic = Topic(
      snapshot.id,
      title,
      topicData['createdAt'].toDate(),
      currentUser,
    );
    final Message firstMessage = Message(
      firstMessageContent,
      currentUser.name,
      currentUser,
      topic,
    );
    firstMessage.sendMessage();
    return topic;
  }

  static Future<List<Topic>> fetch() async {
    final store = FirebaseFirestore.instance;
    final userRef = store
      .collection('users')
      .doc();
    final snapshot = await store.collection('topics').where('isActive', isEqualTo: true).get();
    List<Topic> docs = [];
    for(var doc in snapshot.docs) {
      final docId = doc.id;
      var docData = doc.data();
      final userRef = docData['userReference'];
      docs.add(
        Topic(
          docId,
          docData['title'],
          docData['createdAt'].toDate(),
          await User.transModelFromRef(userRef),
        )
      );
    }
    return docs;
  }

  static Topic find() {
    return Topic(
      "",
      "",
      DateTime(1),
      User(
        '',
        '',
        '',
      ),
    );
  }

  Topic update(String _id, String _title, String _content) {
    return Topic(
      "",
      "",
      DateTime(1),
      User(
        '',
        '',
        '',
      ),
    );
  }
}
