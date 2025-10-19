import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class AIIdentifierScreen extends StatefulWidget {
  const AIIdentifierScreen({super.key});

  @override
  _AIIdentifierScreenState createState() => _AIIdentifierScreenState();
}

class _AIIdentifierScreenState extends State<AIIdentifierScreen> {
  // Function to access camera with permission check
  Future<void> _takePicture() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      try {
        final XFile? image = await picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          File imageFile = File(image.path);
          if (mounted) { // Ensure context is still valid
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Picture taken: ${imageFile.path}')),
            );
          }
         
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No picture taken')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error taking picture: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
      }
    }
  }
  // Function to upload photo from gallery with permission check
Future<void> _uploadPhoto() async {
  try {
    PermissionStatus status;

    // On Android 13+, use READ_MEDIA_IMAGES; below, use READ_EXTERNAL_STORAGE
    if (await Permission.photos.isGranted || await Permission.storage.isGranted) {
      status = PermissionStatus.granted;
    } else {
      if (Platform.isAndroid) {
        if (await Permission.photos.request().isGranted ||
            await Permission.storage.request().isGranted) {
          status = PermissionStatus.granted;
        } else {
          status = PermissionStatus.denied;
        }
      } else {
        // iOS or other
        status = await Permission.photos.request();
      }
    }

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null && mounted) {
        File imageFile = File(image.path);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo uploaded: ${imageFile.path}')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No photo selected')),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gallery permission denied')),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Plant Identifier',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  Text(
                    "Recognize your Plant",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Choose how you want to identify your plant",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Camera button
            ElevatedButton(
              onPressed: _takePicture,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                minimumSize: Size(250, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt, size: 50, color: Colors.white),
                  SizedBox(height: 1),
                  Text(
                    "Recognize Plant with Camera",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Use your camera to take a picture of the plant",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Upload button
            ElevatedButton(
              onPressed: _uploadPhoto, // Placeholder for upload action
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
                minimumSize: Size(250, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_upload, size: 50, color: Colors.white),
                  SizedBox(height: 2),
                  Text(
                    "Upload a Photo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Upload a photo from your gallery",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}