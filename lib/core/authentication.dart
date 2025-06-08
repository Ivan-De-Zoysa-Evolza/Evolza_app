import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future signWithEmailAndPassword(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        // Create a user document in Firestore upon successful registration
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': '',
          'phoneNumber': '',
          'profilePictureUrl': '',
        });
      return true;
      }
    } on FirebaseAuthException catch(e){
      return e.message;
    }
      }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }
}
// try create models (User)
// use lowercase for folders