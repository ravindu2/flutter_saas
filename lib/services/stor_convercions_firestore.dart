import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_saas/model/conversion_model.dart';
import 'package:flutter_saas/services/store_convercions_storage.dart';

class StorConvercionsFirestore {
  final FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> storeConvercionData({
    required conversionData,
    required conversionDate,
    required imageFile,
  }) async {
    try {
      if (_firebaseAuth.currentUser == null) {
        await _firebaseAuth.signInAnonymously();
      }

      final userId = _firebaseAuth.currentUser!.uid;

      final String imageUrl = await StoreConvercionsStorage().uploadImage(
        conversionImage: imageFile,
        userId: userId,
      );

      CollectionReference conversion = _firebaseStorage.collection("conversions");

      final ConversionModel conversionModel = ConversionModel(
        userId: userId,
        conversionData: conversionData,
        conversionDate: conversionDate,
        imageUrl: imageUrl,
      );

      await conversion.add(conversionModel.toJson());

      print("data stored");
    } catch (error) {
      print("Error from firestore:$error");
    }
  }
}
