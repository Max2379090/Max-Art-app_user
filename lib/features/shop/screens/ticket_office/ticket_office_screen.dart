import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'option_page/shooting_photo.dart';

class TicketOfficeScreen extends StatelessWidget {
  const TicketOfficeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for grid items
    final List<Map<String, dynamic>> items = [
      {'image': 'assets/images/content/GettyImages-486359014_0.jpg', 'text': 'Beauty', 'color': 0xff5d4037, 'route': null},
      {'image': 'assets/images/content/eos-80d-2.jpg', 'text': 'Shooting Photo', 'color': 0xff9e9e9e, 'route':StudioPage()},
      {'image': 'assets/images/content/TICKET.jpg', 'text': 'Tickets', 'color': 0xff304ffe, 'route': null},
      {'image': 'assets/images/content/Thai_Elephants_Massage_Spa_Viersen_03.jpg', 'text': 'Care', 'color': 0xffffd600, 'route': null},
      {'image': 'assets/images/content/fitness.jpg', 'text': 'Sport', 'color': 0xff000000, 'route': null},
      {'image': 'assets/images/content/plane ticket.jpg', 'text': 'Plane Ticket', 'color': 0xff3f51b5, 'route': null},
      {'image': 'assets/images/content/Hotel.jpg', 'text': 'Hotel', 'color': 0xFF03A9F4, 'route': null},
      {'image': 'assets/images/content/Vehicle rental.jpg', 'text': 'Vehicle rental', 'color': 0xFF8BC34A, 'route': null},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.6,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (items[index]['route'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => items[index]['route']),
                      );
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(items[index]['color']), // Fixed color parsing
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              items[index]['image'],
                              width: double.infinity,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            items[index]['text'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
