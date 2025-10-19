// add_plant.dart
import 'package:flutter/material.dart';

class AddPlantScreen extends StatelessWidget {
  const AddPlantScreen({super.key});

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
      body: const AddPlantForm(),  // Delegate the form to the stateful widget
    );
  }
}

class AddPlantForm extends StatefulWidget {
  const AddPlantForm({super.key});

  @override
  State<AddPlantForm> createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlantForm> {
  final ScrollController _scrollbar = ScrollController();

  // Form controllers (to manage input values)
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _lastWateredController = TextEditingController();
  final TextEditingController _wateringFreqController = TextEditingController();
  final TextEditingController _fertilizingFreqController = TextEditingController();
  final TextEditingController _careNotesController = TextEditingController();

  // State for dropdown and switch
  String? _selectedSpecies = 'Select Species';
  bool _notificationsEnabled = false;

  @override
  void dispose() {
    _scrollbar.dispose();
    _plantNameController.dispose();
    _lastWateredController.dispose();
    _wateringFreqController.dispose();
    _fertilizingFreqController.dispose();
    _careNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollbar,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollbar,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    // implement image picker here
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.photo, size: 60, color: Colors.grey),
                        SizedBox(height: 30, width: 300),
                        Text(
                          "Tap to add plant photo",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Plant Name',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black),
                  prefixIcon: Icon(
                    Icons.local_florist,
                    color: Colors.yellow,
                    size: 30,),
                ),
                controller: _plantNameController,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Species',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black),
                  prefixIcon: Icon(
                    Icons.grass,
                    color: Colors.green,
                    size: 30,),
                ),
                items: <String>[
                  'Select Species',
                  'Rose',  // Add real species options here
                  'Tulip',
                  'Cactus',
                  'Fern',
                  // ... more
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSpecies = newValue;
                  });
                },
                value: _selectedSpecies,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Last Watered',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black),
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                    size: 30,),
                ),
                controller: _lastWateredController,
                // TODO: Add date picker on tap (e.g., showDatePicker)
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Watering Frequency (days)',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black),
                  prefixIcon: Icon(
                    Icons.water_drop,
                    color:Colors.blueAccent,
                    size: 30,),
                ),
                controller: _wateringFreqController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Fertilizing Frequency',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black),
                  prefixIcon: Icon(
                    Icons.local_dining,
                    color: Colors.orange,
                    size: 30,),
                ),
                controller: _fertilizingFreqController,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Care Notes',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black), 
                  prefixIcon: Icon(
                    Icons.notes,
                    color: Colors.brown,
                    size: 30,),
                ),
                controller: _careNotesController,
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Colors.purple,
                    size: 30,),
                  SizedBox(width: 10),
                  Text('Enable Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black)),
                  Spacer(),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding:  EdgeInsets.only(bottom: 20)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle cancel: Go back
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red
                      ),),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Handle save logic - validate, save to DB/provider, etc.
                      // For example, collect data:
                      // String name = _plantNameController.text;
                      // Then pop or show success
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Plant saved!')),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                    child: Text(
                      'Save Plant',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white),
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