import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Patient to Firestore
  Future<void> addPatient(
      String uid, String name, String email, String userRole) async {
    try {
      await _firestore.collection('patients').doc(uid).set({
        'name': name,
        'email': email,
        'user_role': userRole,
      });
    } catch (e) {
      throw Exception("Error adding user: ${e.toString()}");
    }
  }

  // Add Guardian to Firestore
  Future<void> addGuardian(
      String uid, String name, String email, String userRole) async {
    try {
      await _firestore.collection('guardians').doc(uid).set({
        'name': name,
        'email': email,
        'user_role': userRole,
        'patient_id': '',
      });
    } catch (e) {
      throw Exception("Error adding user: ${e.toString()}");
    }
  }

  // Add guardian-invites to Firestore
  Future<void> addGuardianInvite(String inviteToken, String patientId,
      String guardianName, String guardianEmail, String guardianPhone) async {
    try {
      await _firestore.collection('guardian_invites').doc(inviteToken).set({
        'patient_id': patientId,
        'guardian_name': guardianName,
        'guardian_email': guardianEmail,
        'guardian_phone': guardianPhone,
        'expires_at': Timestamp.now().toDate().add(Duration(hours: 24)),
      });
    } catch (e) {
      throw Exception("Error adding user: ${e.toString()}");
    }
  }

  // Get Patient Data by UID
  Future<Map<String, dynamic>?> getPatient(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('patients').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null; // User not found
      }
    } catch (e) {
      throw Exception("Error fetching user: ${e.toString()}");
    }
  }

  // Get Guardian Data by UID
  Future<Map<String, dynamic>?> getGuardian(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('guardians').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null; // User not found
      }
    } catch (e) {
      throw Exception("Error fetching user: ${e.toString()}");
    }
  }

  // Update patient Data
  Future<void> updatePatient(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('patients').doc(uid).update(data);
    } catch (e) {
      throw Exception("Error updating user: ${e.toString()}");
    }
  }

  // Update gaurdian Data
  Future<void> updateGuardian(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('guardians').doc(uid).update(data);
    } catch (e) {
      throw Exception("Error updating user: ${e.toString()}");
    }
  }
}
