import 'package:flutter/material.dart';
import 'package:music_apk/widgets/playlist_card.dart';
import 'package:music_apk/widgets/song_list.dart';
import 'package:music_apk/api/music_api.dart';
import '../widgets/bottom_navbar.dart';
import 'music_player_page.dart';
import 'search_page.dart';
import 'library_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<dynamic> songs = [];

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    final fetchedSongs = await SoundCloudApi().fetchSongs();
    setState(() {
      songs = fetchedSongs;
    });
  }

  List<Widget> _pages() => [
        HomePageContent(
          songs: songs,
          onPlaySong: playSong,
        ),
        const SearchPage(),
        const LibraryPage(),
        const ProfilePage(),
      ];

  void playSong(song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerPage(song: song),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo.png', height: 25),
                    const SizedBox(width: 8),
                    const Text(
                      'Raag',
                      style: TextStyle(
                          color: Color(0xFFF39F59),
                          fontSize: 24,
                          fontFamily: 'KumbhSans',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: _pages()[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final List<dynamic> songs;
  final Function(dynamic) onPlaySong;

  const HomePageContent({
    Key? key,
    required this.songs,
    required this.onPlaySong,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE9B9BF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.black),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.mic, color: Colors.black),
                  SizedBox(width: 12),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const PlaylistSection(),
            const SizedBox(height: 20),
            SongList(
              songs: songs,
              onPlaySong: onPlaySong,
            ),
          ],
        ),
      ),
    );
  }
}
