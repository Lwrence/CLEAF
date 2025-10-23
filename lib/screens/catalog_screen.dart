import 'dart:io';
import 'package:flutter/material.dart';
import 'SubScreen/add_plant.dart';
import 'SubScreen/ai_identifier.dart';
import '../data/plant_data.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Get all plants
    final plants = PlantData.allPlants
        .where((plant) =>
            plant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            plant.species.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
          const SizedBox(height: 20),

          // 🔍 Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search plants...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🌿 Plant List
          Expanded(
            child: plants.isEmpty
                ? const Center(
                    child: Text(
                      'No plants added yet 🌱',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: plant.imagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(plant.imagePath!),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.local_florist,
                                  size: 40, color: Colors.green),
                          title: Text(
                            plant.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Species: ${plant.species}\n'
                            'Water: ${plant.wateringDays.join(', ')} days\n'
                            'Fertilize every: ${plant.fertilizingDate} \n'
                            'Care Notes: ${plant.notes?.isNotEmpty == true ? plant.notes : "None"}',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ➕ Floating Action Buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              // Wait for AddPlantScreen to finish, then refresh
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPlantScreen()),
              );
              setState(() {}); // refresh list after returning
            },
            backgroundColor: Colors.greenAccent,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AIIdentifierScreen()),
              );
            },
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
