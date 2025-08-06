import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addVisitor({required String name, required String purpose, required String houseNumber}) async {
    await _db.collection('visitors').add({
      'name': name,
      'purpose': purpose,
      'houseNumber': houseNumber,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
