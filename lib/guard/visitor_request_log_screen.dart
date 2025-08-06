// lib/guard/visitor_request_log_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorRequestLogScreen extends StatelessWidget {
  const VisitorRequestLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Visitor Request Log")),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _firestore
            .collection('visitor_requests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) return const Center(child: Text("No requests found."));

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                child: ListTile(
                  title: Text(request['name']),
                  subtitle: Text("Purpose: ${request['purpose']} - House: ${request['houseNumber']}"),
                  trailing: Text(
                    request['status'].toUpperCase(),
                    style: TextStyle(
                      color: request['status'] == 'approved'
                          ? Colors.green
                          : request['status'] == 'denied'
                          ? Colors.red
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
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
