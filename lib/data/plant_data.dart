import '../models/plant_model.dart';

class PlantData {
  static final List<Plant> _plants = [];

  static List<Plant> get allPlants => _plants;

  static void addPlant({
    required String name,
    required String species,
    String? imagePath,
    required List<String> wateringDays,
    required String fertilizingDate,
    String? lastWatered,
    String? notes,
    bool notificationsEnabled = false,
  }) {
    final newPlant = Plant(
      name: name,
      species: species,
      imagePath: imagePath,
      wateringDays: wateringDays,
      fertilizingDate: fertilizingDate,
      lastWatered: lastWatered,
      notes: notes,
      notificationsEnabled: notificationsEnabled,
    );

    _plants.add(newPlant);
  }
}