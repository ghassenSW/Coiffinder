import 'dart:io'; // Add this import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Configurations", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [Icon(Icons.settings)],
        ),
        body: ConfigurationsScreen(),
      ),
    );
  }
}

class ConfigurationsScreen extends StatefulWidget {
  @override
  _ConfigurationsScreenState createState() => _ConfigurationsScreenState();
}

class _ConfigurationsScreenState extends State<ConfigurationsScreen> {
  List<String> configOptions = [
    'Mohamed',
    'Image URL',
    'El Ghazela, Ariana',
    'Additional Infos',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: configOptions.asMap().entries.map((entry) {
          int index = entry.key;
          String defaultValue = entry.value;

          return ConfigOption(
            title: getTitle(index),
            priceRange: defaultValue,
            defaultValue: defaultValue,
            onUpdate: (newValue) {
              updateDefaultValue(newValue, index);
            },
          );
        }).toList(),
      ),
    );
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Center name';
      case 1:
        return 'Center image';
      case 2:
        return 'Center localisation';
      case 3:
        return 'Center informations';
      default:
        return '';
    }
  }

  void updateDefaultValue(String newValue, int index) {
    setState(() {
      configOptions[index] = newValue;
    });
  }
}

class ConfigOption extends StatelessWidget {
  final String title;
  final String priceRange;
  final String defaultValue;
  final Function(String) onUpdate;

  ConfigOption({
    required this.title,
    required this.priceRange,
    required this.defaultValue,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                if (title.toLowerCase() == 'center image') // Show image or white placeholder
                  _buildImageOrPlaceholder()
                else
                  Text(priceRange, style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          if (title.toLowerCase() == 'center image') // Show image picker for the image configuration
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  onUpdate(pickedFile.path);
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              child: Text("Change", style: TextStyle(color: Colors.white)),
            )
          else
            ElevatedButton(
              onPressed: () {
                // Navigate to the second page when the "Change" button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(
                      defaultValue: defaultValue,
                      onUpdate: onUpdate,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              child: Text("Change", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildImageOrPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: priceRange.isNotEmpty
          ? Image.network(
              priceRange,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
          : SizedBox(), // Show white placeholder if no image yet
    );
  }
}

class SecondPage extends StatefulWidget {
  final String defaultValue;
  final Function(String) onUpdate;

  SecondPage({required this.defaultValue, required this.onUpdate});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    valueController = TextEditingController(text: widget.defaultValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Value'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: valueController,
              decoration: InputDecoration(labelText: 'Enter new value'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the callback to update the default value on the first page
                widget.onUpdate(valueController.text);
                // Navigate back to the previous page
                Navigator.pop(context);
              },
              child: Text('Update Value'),
            ),
          ],
        ),
      ),
    );
  }
}
