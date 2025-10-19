import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'SubScreen/plant_detail.dart';

class CareLibraryScreen extends StatelessWidget {
  const CareLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Care Library',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: const CareLibraryForm(),
    );
  }
}

class CareLibraryForm extends StatefulWidget {
  const CareLibraryForm({super.key});

  @override
  State<CareLibraryForm> createState() => _CareLibraryState();
}

class _CareLibraryState extends State<CareLibraryForm> {
  final ScrollController _scrollbar = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  List<dynamic> _plants = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/indoorplants.json');
      final data = json.decode(response);
      setState(() {
        _plants = data;
        _isLoading = false;
      });
      print('✅ Loaded ${_plants.length} plants');
      print('🪴 Names: ${_plants.map((p) => p['name']).toList()}');
    } catch (e) {
      print('❌ Error loading JSON: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openPlantDetail(BuildContext context, String plantName) {
    if (_plants.isEmpty) {
      print('⚠️ No plants loaded yet.');
      return;
    }

    print('🪴 Loaded plants: ${_plants.map((p) => p['name']).toList()}');

    final selectedPlant = _plants.firstWhere(
      (p) => (p['name'] as String).toLowerCase().trim() == plantName.toLowerCase(),
      orElse: () => null,
    );

    if (selectedPlant == null) {
      print('❌ $plantName not found in JSON!');
      return;
    }

    print('✅ Found $plantName: ${selectedPlant['name']}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailScreen(
          name: selectedPlant['name'],
          scientificName: selectedPlant['scientific_name'],
          imagePath:
              'assets/${selectedPlant['image']?['url'] ?? 'plant_images/${plantName.toLowerCase().replaceAll(" ", "_")}.png'}',
          light: selectedPlant['light'],
          wateringFrequency: selectedPlant['watering_frequency'],
          temperature: selectedPlant['temperature'],
          careTips: selectedPlant['care_tips'],
          definition: selectedPlant['definition'],
          water: selectedPlant['water_amount'],
          info: selectedPlant['description'],
        ),
      ),
    );
  }

  Widget _buildPlantCard(BuildContext context, String name, String imagePath) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 220,
      width: 220,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Image.asset(
            imagePath,
            height: 120,
            fit: BoxFit.cover,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          FloatingActionButton.small(
            onPressed: () => _openPlantDetail(context, name),
            shape: const CircleBorder(),
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.book,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollbar.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scrollbar(
      controller: _scrollbar,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollbar,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search plants...',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🌿 All Plant Cards
            _buildPlantCard(context, 'Aloe Vera', 'assets/plant_images/aloe_vera.png'),
            _buildPlantCard(context, 'Peace Lily', 'assets/plant_images/peace_lily.png'),
            _buildPlantCard(context, 'Snake Plant', 'assets/plant_images/snake_plant.png'),
            _buildPlantCard(context, 'ZZ Plant', 'assets/plant_images/zz_plant.png'),
            _buildPlantCard(context, 'Monstera', 'assets/plant_images/monstera.png'),
            _buildPlantCard(context, 'Philodendron', 'assets/plant_images/philodendron.png'),
          ],
        ),
      ),
    );
  }
}
