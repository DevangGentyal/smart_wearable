import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_wearable/pages/patient_page.dart';
import 'package:smart_wearable/pages/guardian_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<String?> _getUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance.collection('patients').doc(uid).get();
    if (doc.exists) {
      return doc['user_role']; // patient or guardian
    }

    // Try guardian collection if not found in patients
    final doc2 =
        await FirebaseFirestore.instance.collection('guardians').doc(uid).get();
    if (doc2.exists) {
      return doc2['user_role'];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('No role found')),
          );
        }

        final role = snapshot.data!;
        if (role == 'Patient') {
          return const PatientHomePage();
        } else if (role == 'Guardian') {
          return const GuardianHomePage();
        } else {
          return const Scaffold(
            body: Center(child: Text('Unknown role')),
          );
        }
      },
    );
  }
}
