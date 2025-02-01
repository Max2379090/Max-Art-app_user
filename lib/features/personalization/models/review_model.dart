class RatingModel {
  final String productId;
  final double rating;
  final String review;
  final String userId;
  final DateTime timestamp;
  final String? productImageUrl;  // Optional image URL for the review image
  final String? profileImageUrl;  // Optional profile image URL for the user

  RatingModel({
    required this.productId,
    required this.rating,
    required this.review,
    required this.userId,
    required this.timestamp,
    this.productImageUrl,  // Add this as optional parameter for review image
    this.profileImageUrl,  // Add this as optional parameter for user profile image
  });

  // Optionally: to/from JSON methods for Firebase or API use.
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      productId: json['productId'],
      rating: json['rating'],
      review: json['review'],
      userId: json['userId'],
      timestamp: DateTime.parse(json['timestamp']),
      productImageUrl: json['productImageUrl'],  // Map the review image URL if it exists
      profileImageUrl: json['profileImageUrl'],  // Map the profile image URL if it exists
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'rating': rating,
      'review': review,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'productImageUrl': productImageUrl,  // Include review image URL in the JSON map
      'profileImageUrl': profileImageUrl,  // Include profile image URL in the JSON map
    };
  }
}
