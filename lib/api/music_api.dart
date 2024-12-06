import 'dart:convert';
import 'package:http/http.dart' as http;

class SoundCloudApi {
  final String apiUrl =
      'https://api.example.com/songs'; // Replace with actual API

  Future<List<dynamic>> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      print('Error fetching songs: $e');
      return [];
    }
  }
}
