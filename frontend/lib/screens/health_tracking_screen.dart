import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/senior.dart';
import 'add_health_data_screen.dart';

class HealthTrackingScreen extends StatelessWidget {
  static List<Senior> seniors = []; // 🔥 Liste globale de seniors

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Suivi des Seniors'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: seniors.isEmpty
          ? Center(
              child: Text(
                'Aucun senior suivi pour le moment.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: seniors.length,
              itemBuilder: (context, index) {
                final senior = seniors[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    title: Text('${senior.name} (ID: ${senior.id})',
                        style: TextStyle(fontSize: 20)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: senior.healthDataList.map((health) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '${health.type} : ${health.value} (${health.date.day}/${health.date.month}/${health.date.year})',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
