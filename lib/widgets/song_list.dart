import 'package:flutter/material.dart';

class SongList extends StatelessWidget {
  final List<dynamic> songs;
  final Function(dynamic) onPlaySong;

  const SongList({
    Key? key,
    required this.songs,
    required this.onPlaySong,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Checkout the Latest Songs!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFE9BCB9),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'kumbh Sans',
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return ListTile(
              leading: Image.network(
                song['coverImage'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                song['title'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                song['artist'],
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.more_vert, color: Colors.white),
              onTap: () => onPlaySong(song),
            );
          },
        ),
      ],
    );
  }
}
