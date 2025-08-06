import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreApprovalTab extends StatefulWidget {
  final String houseNumber;
  const PreApprovalTab({super.key, required this.houseNumber});

  @override
  State<PreApprovalTab> createState() => _PreApprovalTabState();
}

class _PreApprovalTabState extends State<PreApprovalTab> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final purposeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pre-Approve Visitor"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              TextField(
                style: TextStyle(color: Colors.black),
                controller: nameController,
                decoration: const InputDecoration(labelText: "Visitor Name"),
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: purposeController,
                decoration: const InputDecoration(labelText: "Purpose"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty || purposeController.text.isEmpty) return;

                  await FirebaseFirestore.instance.collection('visitor_requests').add({
                    'name': nameController.text,
                    'purpose': purposeController.text,
                    'houseNumber': widget.houseNumber,
                    'status': 'pre-approved',
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pre-approval submitted")),
                  );

                  nameController.clear();
                  purposeController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent
                ),
                child: const Text("Submit Pre-Approval", style: TextStyle( color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
