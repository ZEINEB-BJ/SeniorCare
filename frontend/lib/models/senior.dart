import 'health_data.dart';

class Senior {
  final String id;
  final String name;
  final List<HealthData> healthDataList;

  Senior({
    required this.id,
    required this.name,
    required this.healthDataList,
  });
}
