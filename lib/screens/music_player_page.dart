import 'package:flutter/material.dart';

class MusicPlayerPage extends StatelessWidget {
  final Map<String, dynamic> song;

  const MusicPlayerPage({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song['title']),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(song['thumbnail'], height: 200, width: 200),
            const SizedBox(height: 20),
            Text(song['title'],
                style: const TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 10),
            Text(song['artist'],
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.skip_previous, size: 40, color: Colors.white),
                SizedBox(width: 30),
                Icon(Icons.play_arrow, size: 40, color: Colors.white),
                SizedBox(width: 30),
                Icon(Icons.skip_next, size: 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
