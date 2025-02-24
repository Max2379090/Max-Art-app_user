import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


import '../../../../../utils/constants/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({
          'text': _controller.text,
          'sender': 'me', // 'me' for sent messages, 'other' for received messages
        });
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/logos/max-Store-splash-logo copie2.png'), // Add a profile image
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Text('Customer Service',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                SizedBox(width: 10),
                Text('Online',style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),// Replace with the contact's name
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Show latest messages at the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                final isMe = message['sender'] == 'me';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    textAlign: TextAlign.left,
                    controller: _controller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
    icon: const Icon(Iconsax.paperclip, color: TColors.primary),
    onPressed: () {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Rounded top corners
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOption(context, Icons.dock, "Document", () {}),
                _buildOption(context, Icons.camera, "Camera", () {}),
                _buildOption(context, Icons.image, "Gallery", () {}),
                _buildOption(context, Icons.headphones, "Audio", () {}),
                _buildOption(context, Icons.map, "Location", () {}),
              ],
            ),
          );
        },
      );

    },
    ),
                      prefixIcon: Icon(Icons.emoji_emotions, color: TColors.primary),
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.mic, color: TColors.primary),
                  onPressed: (){}, // Define this function
                ),
                SizedBox(width: 8),
                   IconButton(
                    icon: Icon(Icons.send, color: TColors.primary),
                    onPressed: _sendMessage,
                  ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, size: 28, color: Colors.blue),
    title: Text(label, style: TextStyle(fontSize: 18)),
    onTap: () {
      Navigator.pop(context);
      onTap();
    },
  );
}
