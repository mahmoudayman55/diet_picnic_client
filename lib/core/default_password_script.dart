import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addDefaultPasswordToUsers() async {
  final firestore = FirebaseFirestore.instance;
  final usersCollection = firestore.collection('clients');

  final snapshot = await usersCollection.get();

  // hash function
  String hashPassword(String password) {
    final bytes = utf8.encode(password); // convert to bytes
    final digest = sha256.convert(bytes);
    return digest.toString(); // return hex string
  }

  final defaultPasswordHash = hashPassword("12345678");

  for (var doc in snapshot.docs) {
    final data = doc.data();

    // only update if password doesn't exist
    if (!data.containsKey('password')) {
      await usersCollection.doc(doc.id).update({
        'password': defaultPasswordHash,
      });
      print("✅ Added hashed password for user: ${doc.id}");
    } else {
      print("⏩ Skipped (already has password): ${doc.id}");
    }
  }

  print("🎉 Finished updating users");
}
