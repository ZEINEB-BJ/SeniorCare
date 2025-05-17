import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/medicine.dart';
import 'add_medicine_screen.dart';

class NotificationScreen extends StatelessWidget {
  static List<String> healthAlerts = []; // 🔥 Liste globale des alertes santé
  static List<String> sosAlerts = []; // 🔥 Liste réelle des SOS envoyés

  @override
  Widget build(BuildContext context) {
    final List<Medicine> medicines = AddMedicineScreen.medicines;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Alertes Santé",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (healthAlerts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Aucune alerte santé détectée",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ...healthAlerts.map((alert) => Card(
                color: Colors.orangeAccent.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: Icon(Icons.monitor_heart, color: Colors.white),
                  title: Text(alert,
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              )),
          SizedBox(height: 30),
          Text(
            "Alertes SOS",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (sosAlerts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Aucun SOS envoyé pour le moment",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ...sosAlerts.map((alert) => Card(
                color: Colors.redAccent.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: Icon(Icons.warning_amber, color: Colors.white),
                  title: Text(alert,
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              )),
          SizedBox(height: 30),
          Text(
            "Rappels de Médicaments",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (medicines.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Aucun médicament ajouté",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ...medicines.map((med) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading:
                      Icon(Icons.medication, color: AppColors.primaryColor),
                  title: Text(med.name, style: TextStyle(fontSize: 20)),
                  subtitle: Text(
                    'Date : ${med.date.day}/${med.date.month}/${med.date.year} • Heure : ${med.time}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
