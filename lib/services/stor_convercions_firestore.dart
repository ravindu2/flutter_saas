import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_saas/model/conversion_model.dart';
import 'package:flutter_saas/services/store_convercions_storage.dart';

class StorConvercionsFirestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> storeConvercionData({
    required String conversionData,
    required DateTime conversionDate,
    required imageFile,
  }) async {
    try {
      if (_firebaseAuth.currentUser == null) {
        await _firebaseAuth.signInAnonymously();
      }

      final userId = _firebaseAuth.currentUser!.uid;
      print("Storing data for user: $userId");

      // Uploading the image
      final String imageUrl = await StoreConvercionsStorage().uploadImage(
        conversionImage: imageFile,
        userId: userId,
      );
      print("Image uploaded to: $imageUrl");

      // Creating conversion model
      final ConversionModel conversionModel = ConversionModel(
        userId: userId,
        conversionData: conversionData,
        conversionDate: conversionDate,
        imageUrl: imageUrl,
      );

      // Storing conversion model in Firestore
      await _firebaseFirestore.collection("conversions").add(conversionModel.toJson());
      print("Data stored successfully.");
    } catch (error) {
      print("Error storing conversion data: $error");
    }
  }

  // Fetch user conversion data with error handling
  Stream<List<ConversionModel>> getUserConversion() {
    final userId = _firebaseAuth.currentUser?.uid;

    if (userId == null) {
      print("Error: No user is currently signed in.");
      return Stream.empty(); // Return an empty stream
    }

    try {
      return _firebaseFirestore
          .collection("conversions")
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ConversionModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      print("Error fetching user conversions: $error");
      return Stream.empty(); // Return an empty stream on error
    }
  }
}
