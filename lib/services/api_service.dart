import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: unused_import
import '../config/api_config.dart';

class ApiService {
  Future<dynamic> get(String url) async {
    try {
      print('GET Request to: $url'); // Untuk debugging
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}'); // Untuk debugging
      print('Response body: ${response.body}'); // Untuk debugging
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load data: ${response.statusCode}');
    } catch (e) {
      print('Error in GET request: $e'); // Untuk debugging
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    try {
      print('POST Request to: $url'); // Untuk debugging
      print('Request body: $body'); // Untuk debugging
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );
      
      print('Response status: ${response.statusCode}'); // Untuk debugging
      print('Response body: ${response.body}'); // Untuk debugging

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to post data: ${response.statusCode}');
    } catch (e) {
      print('Error in POST request: $e'); // Untuk debugging
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    try {
      print('PUT Request to: $url'); // Untuk debugging
      print('Request body: $body'); // Untuk debugging
      
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );
      
      print('Response status: ${response.statusCode}'); // Untuk debugging
      print('Response body: ${response.body}'); // Untuk debugging

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to update data: ${response.statusCode}');
    } catch (e) {
      print('Error in PUT request: $e'); // Untuk debugging
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> delete(String url, int id) async {
    try {
      final deleteUrl = '$url?id=$id';
      print('DELETE Request to: $deleteUrl'); // Untuk debugging
      
      final response = await http.delete(Uri.parse(deleteUrl));
      print('Response status: ${response.statusCode}'); // Untuk debugging
      print('Response body: ${response.body}'); // Untuk debugging

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to delete data: ${response.statusCode}');
    } catch (e) {
      print('Error in DELETE request: $e'); // Untuk debugging
      throw Exception('Network error: $e');
    }
  }
} 