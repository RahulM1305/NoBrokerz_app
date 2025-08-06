import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../directory/log_book_tab.dart';
import 'request_approval_screen.dart';
import 'visitor_request_log_screen.dart';

class GuardHome extends StatefulWidget {
  const GuardHome({super.key});

  @override
  State<GuardHome> createState() => _GuardHomeState();
}

class _GuardHomeState extends State<GuardHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _visitorStream;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _visitorStream = _firestore
        .collection('visitor_requests')
        .orderBy('timestamp', descending: true)
        .snapshots();

    _visitorStream.listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        final doc = docChange.doc;
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'];
        final notified = data['notifiedToGuard'] ?? false;

        // Only notify if status is not pending and hasn't already been notified
        if (status != 'pending' && notified == false) {
          final name = data['name'] ?? 'Visitor';
          final house = data['houseNumber'] ?? 'Unknown';

          final action = status == 'approved'
              ? 'Approved'
              : status == 'denied'
              ? 'Denied'
              : 'Pre-Approved';

          if (context.mounted) {
            _showPopup("$action by House $house", "$name's visit was $action.");
          }

          // Mark as notified
          doc.reference.update({'notifiedToGuard': true});
        }
      }
    });
  }

  void _showPopup(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Guard Panel"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionCard(
              context,
              title: "Request Visitor Approval",
              icon: Icons.how_to_reg,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RequestApprovalScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: "Resident Log Book",
              icon: Icons.book,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LogBookTab()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: "View Request Log",
              icon: Icons.history,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VisitorRequestLogScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 36, color: Colors.blueAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
