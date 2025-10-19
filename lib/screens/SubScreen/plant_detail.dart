import 'package:flutter/material.dart';

class PlantDetailScreen extends StatelessWidget {
  final String name;
  final String scientificName;
  final String imagePath;
  final String light;
  final String wateringFrequency;
  final String temperature;
  final String careTips;
  final String definition;
  final String water;
  final String info;

  const PlantDetailScreen({
    super.key,
    required this.name,
    required this.scientificName,
    required this.imagePath,
    required this.light,
    required this.wateringFrequency,
    required this.temperature,
    required this.careTips,
    required this.definition,
    required this.water,
    required this.info, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.greenAccent.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 200,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                size: 100,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric( vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        scientificName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          definition,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 🌿 Info Cards (2x2 layout)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoCard(
                            icon: Icons.water_drop,
                            iconColor: Colors.blueAccent,
                            label: 'Water',
                            value: water,
                          ),
                          _buildInfoCard(
                            icon: Icons.calendar_today,
                            iconColor: Colors.teal,
                            label: 'Frequency',
                            value: wateringFrequency,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoCard(
                            icon: Icons.wb_sunny,
                            iconColor: Colors.orangeAccent,
                            label: 'Light',
                            value: light,
                          ),
                          _buildInfoCard(
                            icon: Icons.thermostat,
                            iconColor: Colors.deepOrange,
                            label: 'Temperature',
                            value: temperature,
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                '📕 Description',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              info,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                '🪴 Care Tips',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              careTips,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      width: 160,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
