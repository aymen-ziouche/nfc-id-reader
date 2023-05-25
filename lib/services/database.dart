import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nfc_id_reader/modules/myData.dart';

class Database {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveinfo(MyData mydata) async {
    final user = _auth.currentUser;

    // Save the user's information on Firestore
    await _firestore.collection('users').doc(user?.uid).update({
      "firstname": mydata.firstname,
      "lastname": mydata.lastname,
      "country": mydata.country,
      "nationality": mydata.nationality,
      "doc_code": mydata.doc_code,
      "doc_num": mydata.doc_num,
      "date_of_birth": mydata.date_of_birth,
      "date_of_expiry": mydata.date_of_expiry,
      "image": mydata.image,
    });
  }

  Future<void> updateinfo(String name, String email, String newemail,
      String password, String newpassword) async {
    final user = _auth.currentUser;
    final credential =
        EmailAuthProvider.credential(email: email, password: password);

    try {
      await user!.reauthenticateWithCredential(credential);

      // Update the email

      await user.updateEmail(newemail);

      // Update the password
      await user.updatePassword(newpassword);

      print('Email and password updated successfully');
    } catch (e) {
      print('Error updating email and password: $e');
    }
    // Save the user's information on Firestore
    await _firestore.collection('users').doc(user!.uid).update({
      'name': name,
      'email': email,
    });
  }

  Future<void> delete() async {
    final user = _auth.currentUser;

    await _firestore.collection('users').doc(user?.uid).delete();
  }
}