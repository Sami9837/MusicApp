import 'package:flutter/material.dart';

class PlaylistSection extends StatelessWidget {
  const PlaylistSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            'My Playlists',
            style: const TextStyle(
              color: Color(0xFFF39F59),
              fontSize: 20,
              fontFamily: 'KumbhSans',
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Flexible(
              child: PlaylistCard(
                title: 'Playlist 1',
                coverImage: 'assets/playlist1.png',
                songCount: 12,
                height: 170,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: PlaylistCard(
                title: 'Playlist 2',
                coverImage: 'assets/playlist2.png',
                songCount: 15,
                height: 170,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final String title;
  final String coverImage;
  final int songCount;
  final double height;

  const PlaylistCard({
    Key? key,
    required this.title,
    required this.coverImage,
    required this.songCount,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              coverImage,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF39F59),
                fontSize: 16,
                fontFamily: 'KumbhSans',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$songCount songs',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'KumbhSans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
