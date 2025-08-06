import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nobrokerz_app/resident/pre_approval_tab.dart';

import 'approval_requests_tab.dart';
import '../directory/log_book_tab.dart';


class ResidentDashboardScreen extends StatelessWidget {
  final String houseNumber;
  const ResidentDashboardScreen({super.key, required this.houseNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Resident - $houseNumber"),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
              title: "Pre-Approve Visitor",
              icon: Icons.verified_user_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PreApprovalTab(houseNumber: houseNumber),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: "Approve / Deny Requests",
              icon: Icons.how_to_reg_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ApprovalRequestsTab(houseNumber: houseNumber),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: "Resident Log Book",
              icon: Icons.book_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LogBookTab(),
                  ),
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
