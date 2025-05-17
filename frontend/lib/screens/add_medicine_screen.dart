import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import '../models/medicine.dart';
import 'notification_screen.dart';

class AddMedicineScreen extends StatefulWidget {
  static List<Medicine> medicines =
      []; // 🔥 Liste globale de médicaments ajoutés

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController _medicineNameController = TextEditingController();
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addMedicine() {
    if (_medicineNameController.text.isNotEmpty &&
        _selectedTime != null &&
        _selectedDate != null) {
      AddMedicineScreen.medicines.add(
        Medicine(
          name: _medicineNameController.text,
          date: _selectedDate!,
          time: _selectedTime!.format(context),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Médicament ajouté avec succès ✅')),
      );
      Navigator.pop(context); // Retour après ajout
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
        title: Text('Ajouter un Médicament'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              hintText: "Nom du médicament",
              controller: _medicineNameController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                _selectedTime == null
                    ? 'Choisir Heure de Prise'
                    : 'Heure choisie : ${_selectedTime!.format(context)}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                _selectedDate == null
                    ? 'Choisir Date de Début'
                    : 'Date choisie : ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            CustomButton(
              text: 'Ajouter Médicament',
              onPressed: _addMedicine,
            ),
          ],
        ),
      ),
    );
  }
}
