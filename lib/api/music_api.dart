import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicApi {
  final String apiUrl = 'https://example.com/api/songs';

  Future<List<dynamic>> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
