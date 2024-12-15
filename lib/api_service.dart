import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the API
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Fetch medicine information by name
  static Future<List<dynamic>> fetchMedicineInfo(String medicineName) async {
    final url = Uri.parse('$baseUrl/medicines?medicineName=$medicineName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to fetch medicine information: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching medicine information: $error');
    }
  }

  // Fetch pharmacy information by medicine name, latitude, and longitude
  static Future<List<Map<String, dynamic>>> fetchPharmacyInfo(
      String medicineName, double latitude, double longitude) async {
    final url = Uri.parse(
        '$baseUrl/stocks/search/$medicineName?latitude=$latitude&longitude=$longitude');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return (json.decode(response.body) as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to fetch pharmacy information: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching pharmacy information: $error');
    }
  }
}