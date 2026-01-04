import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================================
  // REGISTER USER
  // ================================
  Future<dynamic> register(String email, String password, String role) async {
    try {
      // Create Firebase Auth user
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        uid: userCred.user!.uid,
        email: email,
        role: role,
        banned: false, 
      );


      // Save user to Firestore
      await _db.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "email": email,
        "role": role,
        "banned": false, 
        "createdAt": Timestamp.now(),
      });


      return "success";
    } on FirebaseAuthException catch (e) {
      // RETURN FIREBASE ERROR MESSAGE TO UI
      return e.message ?? "Registration failed.";
    } catch (e) {
      return "Error: $e";
    }
  }

  // ================================
  // LOGIN USER
  // ================================
  Future<dynamic> login(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot snap =
          await _db.collection("users").doc(userCred.user!.uid).get();

      if (!snap.exists) {
        return "User data missing in Firestore";
      }

      return UserModel.fromMap(snap.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed.";
    } catch (e) {
      return "Error: $e";
    }
  }

  // ================================
  // LOGOUT
  // ================================
  Future<void> logout() async {
    await _auth.signOut();
  }
}
