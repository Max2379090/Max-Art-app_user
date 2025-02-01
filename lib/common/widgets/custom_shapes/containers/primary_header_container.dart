import 'package:flutter/material.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

/// A container widget with a primary color background and curved edges.
class TPrimaryHeaderContainer extends StatelessWidget {
  /// Create a container with a primary color background and curved edges.
  ///
  /// Parameters:
  ///   - child: The widget to be placed inside the container.
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFEAC5E), // Orange chaleureux
              Color(0xFFC779D0), // Violet doux
              Color(0xFF4BC0C8), // Bleu turquoise
              Color(0xFF2E3192), // Bleu profond
            ],
            begin: Alignment.topLeft, // Point de départ du dégradé
            end: Alignment.bottomRight, // Point de fin du dégradé
            stops: [0.1, 0.4, 0.7, 1.0], // Position des couleurs dans le dégradé
          ),
        ),
        padding: const EdgeInsets.only(bottom: 0),

        /// -- Si l'erreur [size.isFinite': is not true.in Stack] apparaît -> Lire README.md au [DESIGN ERRORS] # 1
        child: Stack(
          children: [
            /// -- Formes personnalisées en arrière-plan
            Positioned(
              top: -150,
              right: -250,
              child: TCircularContainer(backgroundColor: Colors.white.withOpacity(0.1)),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: TCircularContainer(backgroundColor: Colors.white.withOpacity(0.1)),
            ),
            child,
          ],
        ),
      )

    );
  }
}
