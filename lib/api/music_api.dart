import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicApi {
  final String apiUrl = 'https://api.spotify.com/v1';
  final String accessToken = 'your_access_token_here';

  Future<List<dynamic>> fetchPlaylists() async {
    try {
      final url = Uri.parse('$apiUrl/browse/featured-playlists');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['playlists']['items'] ?? [];
      } else {
        throw Exception('Failed to load playlists: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching playlists: $e');
    }
  }

  Future<List<dynamic>> fetchSongs() async {
    try {
      final url = Uri.parse('$apiUrl/browse/new-releases');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['albums']['items'] ?? [];
      } else {
        throw Exception('Failed to load songs: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching songs: $e');
    }
  }
}
