import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalRequestsTab extends StatefulWidget {
  final String houseNumber;
  const ApprovalRequestsTab({super.key, required this.houseNumber});

  @override
  State<ApprovalRequestsTab> createState() => _ApprovalRequestsTabState();
}

class _ApprovalRequestsTabState extends State<ApprovalRequestsTab> {
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Requests"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: _firestore
              .collection('visitor_requests')
              .where('houseNumber', isEqualTo: widget.houseNumber)
              .where('status', isEqualTo: 'pending')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final requests = snapshot.data!.docs;

            if (requests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.inbox, size: 100, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No pending requests.",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.blueAccent),
                    title: Text(request['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Purpose: ${request['purpose']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () {
                            _firestore.collection('visitor_requests').doc(request.id).update({
                              'status': 'approved',
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            _firestore.collection('visitor_requests').doc(request.id).update({
                              'status': 'denied',
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
