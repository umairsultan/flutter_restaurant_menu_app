import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DigitalMenuApp());
}

class DigitalMenuApp extends StatelessWidget {
  const DigitalMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap & Taste',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 1. Updated Data Model matching the API's JSON structure
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  // A factory method to convert the API's JSON into a MenuItem object
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      description: json['dsc'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['img'] ?? '',
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // 2. Future variable to hold our data while it loads
  late Future<List<MenuItem>> _menuFuture;

  @override
  void initState() {
    super.initState();
    // Start fetching data exactly once when the screen loads
    _menuFuture = fetchMenuItems(); 
  }

  // 3. The function that actually calls the GitHub API
  Future<List<MenuItem>> fetchMenuItems() async {
    // You can change 'burgers' to 'pizzas', 'desserts', 'drinks', etc.
    final url = Uri.parse('https://free-food-menus-api-two.vercel.app/burgers');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the JSON string into a List of dynamic objects
      List<dynamic> data = jsonDecode(response.body);
      
      // Map the JSON objects into our MenuItem list
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap & Taste Menu', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // 4. FutureBuilder handles loading, error, and success states dynamically
      body: FutureBuilder<List<MenuItem>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          // State A: Still downloading from the internet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          } 
          // State B: Something went wrong (e.g., no internet connection)
          else if (snapshot.hasError) {
            return Center(child: Text('Error loading menu. Check Wi-Fi.'));
          } 
          // State C: Connected, but the API returned an empty list
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu items found.'));
          }

          // State D: Success! Build the list.
          final menuItems = snapshot.data!;
          
          return ListView.builder(
            itemCount: menuItems.length,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Fetch the image from the URL provided by the API
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          // Shows a tiny loading circle just for the image while it downloads
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 80, height: 80,
                              color: Colors.grey[200],
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          },
                          // Shows a broken image icon if the API image link is dead
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80, height: 80,
                              color: Colors.red[50],
                              child: const Icon(Icons.broken_image, color: Colors.red),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Text and Pricing
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              maxLines: 2, // Limits description to 2 lines so UI stays clean
                              overflow: TextOverflow.ellipsis, 
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}