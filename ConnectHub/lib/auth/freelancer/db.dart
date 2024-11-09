import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> saveFormDataToFirestore(String userId, Map<String, dynamic> formData, File? image) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImage(image, userId);
      }

      final Map<String, dynamic> data = {
        'name': formData['name'],
        'age': formData['age'],
        'nationality': formData['nationality'],
        'skills': formData['skills'],
        'profession': formData['profession'],
        'about': formData['about'],
        'services': formData['services'],
        'contact': formData['contact'],
        'language': formData['language'],
        'experience': formData['experience'],
        'projects': formData['projects'],
        'image_url': formData['imageUrl'],
      };

      await _firestore.collection('freelancer').doc(userId).set(data);
      print('Form data saved to Firestore successfully');
    } catch (error) {
      print('Error saving form data to Firestore: $error');
    }
  }

 Future<String?> uploadImage(File image, String userId) async {
    try {
      final ref = _firebaseStorage.ref().child('profile_images').child('$userId.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('freelancer').doc(userId).get();
      return snapshot.data() as Map<String, dynamic>;
    } catch (error) {
      print('Error fetching user data: $error');
      return {};
    }
  }
}