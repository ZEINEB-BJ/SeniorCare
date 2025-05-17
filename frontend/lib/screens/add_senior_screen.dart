import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/senior.dart';
import '../models/health_data.dart';
import 'health_tracking_screen.dart';

class AddSeniorScreen extends StatefulWidget {
  static int seniorCount = 0; // Pour générer des ID automatiques

  @override
  _AddSeniorScreenState createState() => _AddSeniorScreenState();
}

class _AddSeniorScreenState extends State<AddSeniorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _healthValueController = TextEditingController();
  String _selectedHealthType = 'Tension Artérielle';
  final List<String> _healthTypes = [
    'Tension Artérielle',
    'Glycémie',
    'Température',
    'Saturation Oxygène'
  ];

  void _addSenior() {
    if (_nameController.text.isNotEmpty &&
        _healthValueController.text.isNotEmpty) {
      AddSeniorScreen.seniorCount++;
      final newSenior = Senior(
        id: AddSeniorScreen.seniorCount.toString().padLeft(3, '0'),
        name: _nameController.text.trim(),
        healthDataList: [
          HealthData(
            type: _selectedHealthType,
            value: _healthValueController.text.trim(),
            date: DateTime.now(),
          ),
        ],
      );

      HealthTrackingScreen.seniors.add(newSenior);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senior ajouté avec succès ✅')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Ajouter un Senior'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Nom du Senior",
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedHealthType,
              items: _healthTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedHealthType = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Type de Donnée Santé',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _healthValueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Valeur mesurée",
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addSenior,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Ajouter Senior', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
