import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/constants/colors.dart';

class TSettingsMenuNotification extends StatelessWidget {
  const TSettingsMenuNotification({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notifications')
            .where('isRead', isEqualTo: false) // Fetch unread notifications
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // If there are unread notifications, show the icon with the count badge
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 28, color: TColors.primary), // Base notification icon
                Positioned(
                  top: -5, // Adjust the vertical position of the badge
                  right: -5, // Adjust the horizontal position of the badge
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      snapshot.data!.docs.length.toString(), // Unread notification count
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          // If no unread notifications, show just the icon
          return Icon(icon, size: 28, color: TColors.primary);
        },
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
