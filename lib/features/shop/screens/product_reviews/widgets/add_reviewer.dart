import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../personalization/controllers/ratiing_controller.dart';
import '../../../../personalization/controllers/user_controller.dart';
import '../../../../personalization/models/review_model.dart';

class RatingPage extends StatelessWidget {
  final String productId;
  RatingPage({super.key, required this.productId});

  final controllerUser = UserController.instance;

  String _formatTimestamp(DateTime timestamp) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final RatingController controller = Get.put(RatingController());

    // Fetch ratings when the page is loaded
    controller.fetchRatings(productId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? TColors.light : TColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Product Ratings'.tr,
          style: TextStyle(color: isDark ? TColors.light : TColors.black),
        ),
        centerTitle: true,
        backgroundColor: isDark ? TColors.black : TColors.light,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10), // Réduction du padding global
            child: Obx(() {
              double overallRating = controller.ratings.isNotEmpty
                  ? controller.ratings.fold(0.0, (sum, item) => sum + item.rating) /
                  controller.ratings.length
                  : 0.0;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Alignement en haut pour les colonnes
                children: [
                  // Note globale
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        overallRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 50, // Taille de la note globale
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            Iconsax.star1,
                            color: index < overallRating ? Colors.amber : Colors.grey[300],
                            size: 17, // Taille des étoiles
                          );
                        }),
                      ),
                      Text(
                        '${controller.ratings.length} Ratings'.tr,
                        style: const TextStyle(
                          fontSize: 14, // Taille du texte
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10), // Espacement entre les colonnes principales
                  // Nombre de notes et distribution
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10), // Espacement
                        _buildRatingDistributionInline(controller),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),

          Expanded(
            child: Obx(() {
              if (controller.ratings.isEmpty) {
                return Center(
                  child: Text(
                    'No ratings yet.'.tr,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.ratings.length,
                itemBuilder: (context, index) {
                  final rating = controller.ratings[index];

                  return Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal()
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildProfileImage(rating.profileImageUrl),
                                const SizedBox(width: 15),
                                _buildUserInfo(
                                  controllerUser.user.value.fullName,
                                  rating.timestamp,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            _buildStarRating(rating.rating),
                            const SizedBox(height: 5),
                            Text(
                              rating.review,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            if (rating.productImageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // When the image is tapped, show it in full size
                                    _showFullImageDialog(context, rating.productImageUrl!);
                                  },
                                  child: Image.network(
                                    rating.productImageUrl!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () => _showRatingDialog(context, controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              child: Text('Add Rating'.tr),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : const Icon(Icons.account_circle, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildUserInfo(String name, DateTime timestamp) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: TColors.primary),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            _formatTimestamp(timestamp),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          Iconsax.star1,
          color: index < rating ? Colors.amber : Colors.grey[300],
          size: 20,
        );
      }),
    );
  }

  void _showRatingDialog(BuildContext context, RatingController controller) {
    final TextEditingController reviewController = TextEditingController();
    final ValueNotifier<double> ratingValueNotifier = ValueNotifier<double>(5.0);
    XFile? selectedImage;

    // Fonction pour sélectionner une image depuis la galerie
    Future<void> selectImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        selectedImage = pickedImage;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Leave a Review'.tr),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rating'.tr),
                ValueListenableBuilder<double>(
                  valueListenable: ratingValueNotifier,
                  builder: (context, ratingValue, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0), // Add horizontal spacing between the stars
                            child: IconButton(
                              icon: Icon(
                                Iconsax.star1,
                                color: index < ratingValue ? Colors.amber : Colors.grey[300],
                                size: 30,
                              ),
                              onPressed: () => ratingValueNotifier.value = (index + 1).toDouble(),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),



                TextField(
                  controller: reviewController,
                  decoration: InputDecoration(
                    hintText: 'Enter your review'.tr,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Bouton pour sélectionner une image (facultatif)
                GestureDetector(
                  onTap: selectImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: TColors.primary,
                    ),
                    child: Text(
                      selectedImage == null
                          ? 'Select an Image (optional)'.tr
                          : 'Image Selected'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // Si une image est sélectionnée, l'afficher
                if (selectedImage != null) ...[
                  const SizedBox(height: 10),
                  // Afficher l'image avec différentes tailles
                  Image.file(
                    File(selectedImage!.path),
                    width: double.infinity, // Utilise toute la largeur disponible
                    height: 200, // Hauteur fixée
                    fit: BoxFit.cover, // Pour que l'image couvre la zone tout en gardant son aspect
                  ),
                  const SizedBox(height: 10),
                  // Afficher une version réduite de l'image
                  Image.file(
                    File(selectedImage!.path),
                    width: 100, // Largeur fixe plus petite
                    height: 100, // Hauteur fixe
                    fit: BoxFit.cover, // Adaptation à la zone
                  ),
                ],
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust the spacing as needed
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'.tr),
                ),
                TextButton(
                  onPressed: () async {
                    final String? productImageUrl = selectedImage != null
                        ? await _uploadImageToFirebase(selectedImage!)
                        : null;

                    final ratingModel = RatingModel(
                      productId: productId,
                      rating: ratingValueNotifier.value,
                      review: reviewController.text,
                      userId: controllerUser.user.value.id,
                      timestamp: DateTime.now(),
                      productImageUrl: productImageUrl,
                      profileImageUrl: controllerUser.user.value.profilePicture,
                    );

                    controller.addRating(productId, ratingModel);
                    Navigator.pop(context);
                  },
                  child: Text('Submit'.tr),
                ),
              ],
            ),
          ],

        );
      },
    );
  }

  Future<String?> _uploadImageToFirebase(XFile image) async {
    String fileName = path.basename(image.path);
    String filePath = 'product_images/$fileName';
    try {
      final ref = FirebaseStorage.instance.ref().child(filePath);
      await ref.putFile(File(image.path));
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // Show the image in full size
  void _showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows tapping outside to dismiss the dialog
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.7), // Dark background for focus
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Rounded corners
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button at the top-right corner
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Full-screen image display
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6, // Take up 80% of the screen height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.contain, // Ensures the image is fully visible
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _buildRatingDistributionInline(RatingController controller) {
    Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    int totalRatings = controller.ratings.length;

    for (var rating in controller.ratings) {
      int star = rating.rating.toInt();
      ratingCounts[star] = (ratingCounts[star] ?? 0) + 1;
    }

    return Column(
      children: List.generate(5, (index) {
        int starRating = 5 - index; // Commence par 5 étoiles
        int count = ratingCounts[starRating] ?? 0;
        double percentage = totalRatings > 0 ? count / totalRatings : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical:0), // Espacement vertical entre les barres
          child: Row(
            children: [
              // Affiche l'étoile et la barre de progression
              Text(
                '$starRating',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 2), // Espacement entre le texte et la barre
              Expanded(
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: Colors.grey[300],
                  color: starRating >= 4 ? Colors.green : starRating == 3 ? Colors.yellow : Colors.red,
                  minHeight: 5, // Hauteur réduite de la barre
                ),
              ),
              const SizedBox(width: 2), // Espacement à droite
              Text(
                '$count', // Affiche le nombre de votes pour chaque étoile
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }),
    );
  }
}
