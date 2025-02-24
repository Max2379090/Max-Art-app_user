import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/screens/setting/settings.dart';
import 'message page/MessagePage_send.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and repeat the animation in reverse for a pulsing effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDark ? TColors.black : TColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back arrow and top icon
              Row(
                children: [

                  IconButton(icon: Icon(Icons.arrow_back, color:isDark ? TColors.light : TColors.black,), onPressed: () => Get.to(() => const SettingsScreen())),
                  const Spacer(),
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE6FFEB),
                    child: Icon(Icons.headset_mic, color: TColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title Text
              Text.rich(
                TextSpan(
                  text: "Do you have a problem? ".tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.light : TColors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "We're there\nfor you.".tr,
                      style: const TextStyle(color: TColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Image with chat bubble
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated flashing profile image
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value, // Apply the pulsing effect
                          child: const CircleAvatar(
                            radius: 120,
                            backgroundColor: Color(0xFFE6FFEB),
                            child: CircleAvatar(
                              radius: 110,
                              backgroundImage: AssetImage(
                                'assets/images/support_preson/femme.png',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 10,
                      left: 40,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(
                          "Hello!".tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // Buttons
              Center(
                child: Column(
                  children: [
                    // "Write Now" Button
                    ElevatedButton(


                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      onPressed: () { Get.to(() => ChatPage()); },
                      child:Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "write now".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // "Write on WhatsApp" Button
                    OutlinedButton.icon(
                      onPressed: () async {
                        const whatsappUrl = 'https://wa.me/237654235532?text=Hello%20there!';
                        if (await canLaunch(whatsappUrl)) {
                          await launch(whatsappUrl);
                        } else {
                          throw 'Could not launch $whatsappUrl';}
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TColors.primary, side: BorderSide(color: isDark ? TColors.light : TColors.black,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      icon:  Icon(Icons.chat_bubble, color: isDark ? TColors.light : TColors.primary),
                      label:Text(
                        "Write now on WhatsApp".tr,
                        style:  TextStyle(
                          fontSize: 16,
                          color: isDark ? TColors.light : TColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          onPressed: () async {
            const whatsappUrl = 'https://wa.me/237654235532?text=Hello%20there!'; // Replace with your WhatsApp number
            if (await canLaunch(whatsappUrl)) {
              await launch(whatsappUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not launch WhatsApp. Please ensure it is installed.')),
              );
            }
          },
          backgroundColor: Colors.white,
          foregroundColor: TColors.primary,
          tooltip: 'Contact us on WhatsApp',
          child: Image.asset(
            'assets/images/whatsapp/whatsapp.png', // Replace with your image path
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
