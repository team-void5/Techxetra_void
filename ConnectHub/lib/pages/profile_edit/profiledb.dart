import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}

class DatabaseService {
  Future<Map<String, dynamic>> getUserData(String userId) async {
  try {
    Map<String, dynamic> userData = {};

    // Fetch data from the 'freelancer' collection
    DocumentSnapshot freelancerSnapshot = await FirebaseFirestore.instance.collection('freelancer').doc(userId).get();
    if (freelancerSnapshot.exists) {
      userData.addAll(freelancerSnapshot.data() as Map<String, dynamic>);
    }

    // Fetch email from the 'users' collection
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      userData['email'] = userSnapshot.get('email');
    }

    return userData;
  } catch (error) {
    print('Error fetching user data: $error');
    return {};
  }
}
}

