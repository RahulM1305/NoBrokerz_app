import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogBookTab extends StatefulWidget {
  const LogBookTab({super.key});

  @override
  State<LogBookTab> createState() => _LogBookTabState();
}

class _LogBookTabState extends State<LogBookTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resident Log Book"),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('resident_log_book').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No residents registered yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: const Icon(Icons.person, size: 36, color: Colors.blueAccent),
                  title: Text(
                    data['name'] ?? '',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "House: ${data['houseNumber'] ?? ''}\nPhone: ${data['phone'] ?? ''}",
                    style: const TextStyle(fontSize: 16),
                  ),


                ),
              );
            },
          );
        },
      ),
    );
  }
}
