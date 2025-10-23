class Plant {
  final String name;
  final String species;
  final String? imagePath;
  final List<String> wateringDays;
  final String fertilizingDate;
  final String? lastWatered;
  final String? notes;
  final bool notificationsEnabled;

  Plant({
    required this.name,
    required this.species,
    this.imagePath,
    required this.wateringDays,
    required this.fertilizingDate,
    this.lastWatered,
    this.notes,
    this.notificationsEnabled = false,
  });
}
