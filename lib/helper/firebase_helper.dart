import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> uploadTask(List<Map<String, dynamic>> tasks) async {
    String userId = _auth.currentUser!.uid;
    for (var task in tasks) {
      await _firestore.collection('users').doc(userId).collection('notes').add(task);
    }
  }


  Future<List<Map<String, dynamic>>> fetchTask() async {
    String userId = _auth.currentUser!.uid;
    QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('notes').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }


  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // Handle error (e.g., log it or show a message)
      print('Sign in error: $e');
      return null;
    }
  }
}
