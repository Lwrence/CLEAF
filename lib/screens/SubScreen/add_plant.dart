import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/data/plant_data.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final ScrollController _scrollbar = ScrollController();

  // Form controllers
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _lastWateredController = TextEditingController();
  final TextEditingController _wateringFreqController = TextEditingController();
  final TextEditingController _fertilizingFreqController = TextEditingController();
  final TextEditingController _careNotesController = TextEditingController();

  String? _selectedSpecies = 'Select Species';
  bool _notificationsEnabled = false;
  File? _selectedImage;

  // For selecting multiple watering days
  final List<String> _daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  List<String> _selectedDays = [];

  // Fertilizing frequency (weeks)
  int _fertilizingWeeks = 1;

  @override
  void dispose() {
    _scrollbar.dispose();
    _plantNameController.dispose();
    _speciesController.dispose();
    _lastWateredController.dispose();
    _wateringFreqController.dispose();
    _fertilizingFreqController.dispose();
    _careNotesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() => _selectedImage = File(pickedFile.path));
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() => _selectedImage = File(pickedFile.path));
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickLastWateredDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _lastWateredController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickWateringDays() async {
    List<String> tempSelectedDays = List.from(_selectedDays);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Watering Days"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  children: _daysOfWeek.map((day) {
                    return CheckboxListTile(
                      title: Text(day),
                      value: tempSelectedDays.contains(day),
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) {
                            tempSelectedDays.add(day);
                          } else {
                            tempSelectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedDays = tempSelectedDays;
                  _wateringFreqController.text = _selectedDays.join(", ");
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  void _savePlant() {
    PlantData.addPlant(
      name: _plantNameController.text,
      species: _speciesController.text,
      imagePath: _selectedImage?.path,
      wateringDays: _selectedDays,
      fertilizingDate: "${_fertilizingWeeks} week(s)",
      lastWatered: _lastWateredController.text,
      notes: _careNotesController.text,
      notificationsEnabled: _notificationsEnabled,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plant saved!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Add New Plant',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Scrollbar(
        controller: _scrollbar,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollbar,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🪴 Photo Picker (same UI)
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedImage!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.photo, size: 60, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          _selectedImage != null
                              ? "Tap to change photo"
                              : "Tap to add plant photo",
                          style: const TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🌿 Plant Name
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Plant Name',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  prefixIcon: Icon(Icons.local_florist, color: Colors.yellow, size: 30),
                ),
                controller: _plantNameController,
              ),
              const SizedBox(height: 20),

              // 🌾 Species Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Species',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  prefixIcon: Icon(Icons.grass, color: Colors.green, size: 30),
                  border: OutlineInputBorder(),
                ),
                value: _selectedSpecies,
                items: <String>[
                  'Select Species',
                  'Aloe Vera',
                  'Snake Plant',
                  'Peace Lily',
                  'Spider Plant',
                  'Cactus',
                  'Pothos',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    enabled: value != 'Select Species',
                    child: Text(
                      value,
                      style: TextStyle(
                        color: value == 'Select Species' ? Colors.grey : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSpecies = newValue;
                    _speciesController.text = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // 📅 Last Watered
              TextField(
                readOnly: true,
                controller: _lastWateredController,
                onTap: _pickLastWateredDate,
                decoration: const InputDecoration(
                  labelText: 'Last Watered',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.blue, size: 30),
                ),
              ),
              const SizedBox(height: 20),

              // 💧 Watering Frequency (Select Days)
              TextField(
                readOnly: true,
                controller: _wateringFreqController,
                onTap: _pickWateringDays,
                decoration: const InputDecoration(
                  labelText: 'Watering Days',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  prefixIcon: Icon(Icons.water_drop, color: Colors.blueAccent, size: 30),
                ),
              ),
              const SizedBox(height: 20),

              // 🌾 Fertilizing Frequency (in weeks)
              Padding(padding:  const EdgeInsets.only(top: 20)),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Fertilizing Frequency (weeks)',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  prefixIcon: Icon(Icons.local_dining, color: Colors.orange, size: 30),
                  border: OutlineInputBorder(),
                ),
                value: _fertilizingWeeks,
                items: List.generate(
                  8,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    _fertilizingWeeks = newValue!;
                    _fertilizingFreqController.text = '$newValue week(s)';
                  });
                },
              ),
              const SizedBox(height: 20),
              // 📝 Care Notes
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Care Notes',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  prefixIcon: Icon(Icons.notes, color: Colors.brown, size: 30),
                ),
                controller: _careNotesController,
                maxLines: 3,
              ),
              const SizedBox(height: 10),

              // 🔔 Notification Switch
              Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.purple, size: 30),
                  const SizedBox(width: 10),
                  const Text('Enable Notifications',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  const Spacer(),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() => _notificationsEnabled = value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: 18, color: Colors.red)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _savePlant,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent),
                    child: const Text(
                      'Save Plant',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
