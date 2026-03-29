import 'package:flutter/material.dart';

void main() {
  runApp(const DigitalMenuApp());
}

class DigitalMenuApp extends StatelessWidget {
  const DigitalMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Food Menu',
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
      // Removes the debug banner in the top right
      debugShowCheckedModeBanner: false, 
    );
  }
}

// 1. Define a simple Data Model for our menu items
class MenuItem {
  final String name;
  final String description;
  final double price;
  final IconData placeholderIcon;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.placeholderIcon,
  });
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // 2. Hardcode the menu data so it loads instantly in memory
  static const List<MenuItem> _menuItems = [
    MenuItem(
      name: 'Classic Cheeseburger',
      description: 'Beef patty, cheddar cheese, lettuce, tomato, and house sauce.',
      price: 5.99,
      placeholderIcon: Icons.lunch_dining,
    ),
    MenuItem(
      name: 'Spicy Chicken Sandwich',
      description: 'Crispy fried chicken breast with spicy mayo and pickles.',
      price: 6.49,
      placeholderIcon: Icons.fastfood,
    ),
    MenuItem(
      name: 'Large French Fries',
      description: 'Golden, crispy fries salted to perfection.',
      price: 2.99,
      placeholderIcon: Icons.local_pizza, // Placeholder
    ),
    MenuItem(
      name: 'Chocolate Milkshake',
      description: 'Rich chocolate ice cream blended with whole milk.',
      price: 3.99,
      placeholderIcon: Icons.icecream,
    ),
    MenuItem(
      name: 'Fountain Drink',
      description: 'Choice of cola, diet cola, or lemon-lime soda.',
      price: 1.99,
      placeholderIcon: Icons.local_drink,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Menu', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // 3. Use ListView.builder for high performance on long lists
      body: ListView.builder(
        itemCount: _menuItems.length,
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, index) {
          final item = _menuItems[index];
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
                  // Placeholder for your actual food image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.placeholderIcon, size: 40, color: Colors.red),
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
      ),
    );
  }
}