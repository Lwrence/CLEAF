import 'package:flutter/material.dart';
import 'SubScreen/add_plant.dart';
import 'SubScreen/ai_identifier.dart';


class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Plant Catalog',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Search plants...'), // You might want to replace this with a TextField for actual search
                Icon(Icons.search),
              ],
            ),
          ),
          const Expanded( // Wrap the main content in Expanded to take remaining space
            child: Center(
              child: Text('Your catalog content goes here...'), // Placeholder for existing catalog content (e.g., replace with ListView of plants)
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Navigate to the Add Plant screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPlantScreen()),
              );
            },
            backgroundColor: Colors.greenAccent,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16), // Spacing between the two buttons
          FloatingActionButton(
            onPressed: () {
              // Navigate to Scan Plant Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIIdentifierScreen()
              ),
              );
            },
            backgroundColor: Colors.lightBlueAccent, // Different color to distinguish from Add button
            child: const Icon(Icons.camera_alt,
            color: Colors.white,), // Using camera icon for scan
          ),
        ],
      ),
    );
  }
}