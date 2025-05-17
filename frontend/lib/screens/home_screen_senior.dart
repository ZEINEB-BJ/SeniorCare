import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'messaging_screen.dart';
import 'notification_screen.dart';
import 'health_tracking_screen.dart';
import 'add_medicine_screen.dart';
import 'add_health_data_screen.dart';
import 'sos_screen.dart';
import 'senior_messaging_screen.dart';
import 'login_screen.dart';

class HomeScreenSenior extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Tableau de bord Senior'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Flèche pour revenir en arrière
          onPressed: () {
            // Retourner à l'écran de connexion (ou un autre écran précédent)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(context, Icons.smart_toy_outlined, 'Assistant Virtuel',
                MessagingScreen()),
            _buildCard(
              context,
              Icons.message,
              'Messagerie',
              SeniorMessagingScreen(
                  aidantId: 'aidant1', seniorId: 'senior1'), // exemple
            ),
            _buildCard(
                context, Icons.alarm, 'Mes Rappels', NotificationScreen()),
            _buildCard(context, Icons.health_and_safety, 'Suivi Santé',
                HealthTrackingScreen()),
            _buildCard(context, Icons.add_box, 'Ajouter Médicament',
                AddMedicineScreen()),
            _buildCard(context, Icons.add_chart, 'Ajouter Donnée Santé',
                AddHealthDataScreen()),
            _buildCard(context, Icons.warning_amber, 'SOS', SosScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, IconData icon, String label, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: AppColors.primaryColor),
              SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
