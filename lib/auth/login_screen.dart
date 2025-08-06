import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resident/resident_home.dart';
import 'resident_signup_screen.dart';

class ResidentLoginScreen extends StatefulWidget {
  const ResidentLoginScreen({super.key});

  @override
  State<ResidentLoginScreen> createState() => _ResidentLoginScreenState();
}

class _ResidentLoginScreenState extends State<ResidentLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void login() async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = credential.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc['role'] == 'resident') {
        _goToDashboard(doc['houseNumber']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unauthorized user")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.message}")),
      );
    }
  }

  void _goToDashboard(String houseNumber) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResidentDashboardScreen(houseNumber: houseNumber),
      ),
    );
  }

  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResidentSignupScreen(
          prefilledEmail: '',
          prefilledPassword: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resident Login")),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: login, child: const Text("Login")),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _goToSignup,
                child: const Text("New user? Create an account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
