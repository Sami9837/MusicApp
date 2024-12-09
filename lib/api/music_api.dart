import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicApi {
  static const String _baseUrl = "https://task-4-0pfy.onrender.com";

  Future<List<Map<String, dynamic>>> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/songs'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        return jsonData
            .map((song) => {
                  "title": song["title"]?.toString() ?? "Unknown Title",
                  "artist": song["artist"]?.toString() ?? "Unknown Artist",
                  "thumbnail": song["thumbnail"]?.toString() ??
                      "https://via.placeholder.com/150", // Fallback thumbnail
                  "duration": song["duration"]?.toString() ?? "0:00",
                })
            .toList();
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching songs: $error");
      return [];
    }
  }
}
