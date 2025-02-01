import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/personalization/models/review_model.dart';

class RatingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch ratings for a specific product
  Future<List<RatingModel>> getRatings(String productId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Products')
          .doc(productId)
          .collection('Rating')
          .get();

      return snapshot.docs
          .map((doc) => RatingModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch ratings: $e');
    }
  }

  // Add a new rating to a specific product
  Future<void> addRating(String productId, RatingModel rating) async {
    try {
      await _firestore
          .collection('Products')
          .doc(productId)
          .collection('Rating')
          .add(rating.toJson());
    } catch (e) {
      throw Exception('Failed to add rating: $e');
    }
  }

  // Update a specific rating in a product's Ratings subcollection
  Future<void> updateRating(String productId, String ratingId, RatingModel updatedRating) async {
    try {
      await _firestore
          .collection('Products')
          .doc(productId)
          .collection('Rating')
          .doc(ratingId)
          .update(updatedRating.toJson());
    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  // Delete a rating from a product's Ratings subcollection
  Future<void> deleteRating(String productId, String ratingId) async {
    try {
      await _firestore
          .collection('Products') // Fixed collection name to 'Products'
          .doc(productId)
          .collection('Rating')
          .doc(ratingId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete rating: $e');
    }
  }
}
