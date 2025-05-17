import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SosScreen extends StatelessWidget {
  void _sendSOS(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SOS envoyé avec succès 🚨'),
        backgroundColor: Colors.redAccent,
      ),
    );
    Navigator.pop(context); // Retour après envoi SOS
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Bouton SOS'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _sendSOS(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'ENVOYER SOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
