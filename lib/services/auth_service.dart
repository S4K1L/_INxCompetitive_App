import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier{
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  

  // sign user in
Future<UserCredential>signInWithEmailandPassword(
    String email, String password) async{
  try{
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password
        );
// add a new doucment for the user in users collection if it doesn't already exists
    _fireStore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
    }, SetOptions(merge: true));

      return userCredential;
  }
  // catch any error
  on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}

//create new user
  Future<UserCredential> singUpWithEmailAndPassword(
      String email,String password,String fullName) async {
  try{
    UserCredential userCredential =
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
    );

    // after crating the user create a new document for user in the user collection
    _fireStore.collection('users').doc(userCredential.user!.uid).set({
      'uid' : userCredential.user!.uid,
      'email' : email,
      'fullName' : fullName,
    });
    return userCredential;
    } on FirebaseAuthException catch(e){
    throw Exception(e.code);
    }
  }
  // sign user out
Future<void> signOut() async {
  return await FirebaseAuth.instance.signOut();
}

}