import 'package:get/get.dart';
import '../../../data/repositories/rating/rating_repository.dart';
import '../models/review_model.dart';

class RatingController extends GetxController {
  final RatingRepository _ratingRepository = RatingRepository();

  final averageRating = 0.0.obs;
  final ratingCount = 0.obs;
  var ratings = <RatingModel>[].obs;


  // Fetch ratings for a specific product
  Future<void> fetchRatings(String productId) async {
    try {
      List<RatingModel> fetchedRatings = await _ratingRepository.getRatings(productId);

      double sumRatings = fetchedRatings.fold(0.0, (sum, rating) => sum + rating.rating);
      ratingCount.value = fetchedRatings.length;
      averageRating.value = fetchedRatings.isNotEmpty ? sumRatings / fetchedRatings.length : 0.0;

      ratings.assignAll(fetchedRatings);
    } catch (e) {
      print('Error fetching ratings: $e');
    }
  }

  // Add a new rating for a specific product
  Future<void> addRating(String productId, RatingModel rating) async {
    try {
      await _ratingRepository.addRating(productId, rating);
      ratings.add(rating); // Add to the local list
    } catch (e) {
      print('Error adding rating: $e');
    }
  }

  // Update an existing rating for a specific product
  Future<void> updateRating(String productId, String ratingId, RatingModel updatedRating) async {
    try {
      await _ratingRepository.updateRating(productId, ratingId, updatedRating);
      int index = ratings.indexWhere((r) => r.userId == updatedRating.userId);
      if (index != -1) {
        ratings[index] = updatedRating; // Update local list
      }
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  // Calculate the percentage of each rating level
  Map<int, double> calculateRatingPercentages() {
    Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    // Count the occurrences of each rating
    for (var rating in ratings) {
      ratingCounts[rating.rating.toInt()] = (ratingCounts[rating.rating.toInt()] ?? 0) + 1;
    }

    // Calculate percentages
    int totalRatings = ratings.length;
    Map<int, double> ratingPercentages = {};
    if (totalRatings > 0) {
      for (int i = 1; i <= 5; i++) {
        ratingPercentages[i] = (ratingCounts[i]! / totalRatings) * 100;
      }
    }
    return ratingPercentages;
  }
}
