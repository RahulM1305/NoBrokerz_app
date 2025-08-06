import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestApprovalScreen extends StatefulWidget {
  const RequestApprovalScreen({super.key});

  @override
  State<RequestApprovalScreen> createState() => _RequestApprovalScreenState();
}

class _RequestApprovalScreenState extends State<RequestApprovalScreen> {
  final nameController = TextEditingController();
  final purposeController = TextEditingController();
  final houseController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitRequest() async {
    final name = nameController.text.trim();
    final purpose = purposeController.text.trim();
    final houseNumber = houseController.text.trim();

    if (name.isEmpty || purpose.isEmpty || houseNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('houseNumber', isEqualTo: houseNumber)
          .where('role', isEqualTo: 'resident')
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Resident with house number $houseNumber not found")),
        );
        return;
      }

      await _firestore.collection('visitor_requests').add({
        'name': name,
        'purpose': purpose,
        'houseNumber': houseNumber,
        'timestamp': Timestamp.now(),
        'status': 'pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request sent successfully!")),
      );

      nameController.clear();
      purposeController.clear();
      houseController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Request Visitor Approval" ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(labelText: 'Visitor Name'),
            ),
            TextField(
              controller: purposeController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(labelText: 'Purpose'),
            ),
            TextField(
              controller: houseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'House Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent
              ),
              onPressed: _submitRequest,
              child: const Text('Submit Request', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
