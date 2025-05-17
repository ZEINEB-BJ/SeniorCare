import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import '../models/health_data.dart';
import 'notification_screen.dart';

class AddHealthDataScreen extends StatefulWidget {
  static List<HealthData> healthDataList = []; // 🔥 Liste globale données santé

  @override
  _AddHealthDataScreenState createState() => _AddHealthDataScreenState();
}

class _AddHealthDataScreenState extends State<AddHealthDataScreen> {
  final TextEditingController _valueController = TextEditingController();
  String _selectedType = 'Tension Artérielle';
  final List<String> _types = [
    'Tension Artérielle',
    'Glycémie',
    'Température',
    'Saturation Oxygène'
  ];

  void _checkForAlert(HealthData data) {
    bool isCritical = false;
    String alertMessage = "";

    if (data.type == 'Tension Artérielle') {
      final parts = data.value.split('/');
      if (parts.length == 2) {
        final systolic = int.tryParse(parts[0]);
        final diastolic = int.tryParse(parts[1]);
        if (systolic != null &&
            diastolic != null &&
            (systolic > 140 || diastolic > 90)) {
          isCritical = true;
          alertMessage = "Tension élevée détectée : ${data.value}";
        }
      }
    } else if (data.type == 'Glycémie') {
      final glycemia = double.tryParse(data.value);
      if (glycemia != null && (glycemia < 70 || glycemia > 180)) {
        isCritical = true;
        alertMessage = "Anomalie glycémie détectée : ${data.value}";
      }
    } else if (data.type == 'Température') {
      final temp = double.tryParse(data.value);
      if (temp != null && temp > 38) {
        isCritical = true;
        alertMessage = "Fièvre détectée : ${data.value}°C";
      }
    } else if (data.type == 'Saturation Oxygène') {
      final saturation = int.tryParse(data.value);
      if (saturation != null && saturation < 92) {
        isCritical = true;
        alertMessage = "Hypoxie détectée : ${data.value}%";
      }
    }

    if (isCritical) {
      NotificationScreen.healthAlerts.add(alertMessage);
    }
  }

  void _addHealthData() {
    if (_valueController.text.isNotEmpty) {
      final newHealthData = HealthData(
        type: _selectedType,
        value: _valueController.text,
        date: DateTime.now(),
      );

      AddHealthDataScreen.healthDataList.add(newHealthData);
      _checkForAlert(newHealthData); // 🔥 Vérification automatique !

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donnée Santé ajoutée avec succès ✅')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer une valeur')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Ajouter une Donnée Santé'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _types.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Type de donnée',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Valeur mesurée",
              controller: _valueController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            CustomButton(
              text: 'Ajouter Donnée',
              onPressed: _addHealthData,
            ),
          ],
        ),
      ),
    );
  }
}
