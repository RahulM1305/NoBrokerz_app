import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resident/resident_home.dart';

class ResidentSignupScreen extends StatefulWidget {
  final String prefilledEmail;
  final String prefilledPassword;

  const ResidentSignupScreen({
    super.key,
    required this.prefilledEmail,
    required this.prefilledPassword,
  });

  @override
  State<ResidentSignupScreen> createState() => _ResidentSignupScreenState();
}

class _ResidentSignupScreenState extends State<ResidentSignupScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final houseController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.prefilledEmail;
    passwordController.text = widget.prefilledPassword;
  }

  Future<void> signup() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final houseNumber = houseController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || phone.isEmpty || houseNumber.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      // 🔍 Check if house number is already used
      final existing = await _firestore
          .collection('users')
          .where('houseNumber', isEqualTo: houseNumber)
          .get();

      if (existing.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("House Number already in use")),
        );
        return;
      }

      // ✅ Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // ✅ Add user data to Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'phone': phone,
        'houseNumber': houseNumber,
        'email': email,
        'role': 'resident',
      });

      // ✅ Optional: Add to resident log book
      await _firestore.collection('resident_log_book').doc(uid).set({
        'name': name,
        'phone': phone,
        'houseNumber': houseNumber,
        'email': email,
        'joinedAt': Timestamp.now(),
      });

      // ✅ Navigate to dashboard
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResidentDashboardScreen(houseNumber: houseNumber),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Entire screen white
      appBar: AppBar(
        title: const Text("Resident Sign Up"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: houseController,
                decoration: const InputDecoration(labelText: "House Number"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("Create Account", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
