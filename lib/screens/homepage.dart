import 'package:flutter/material.dart';
import '../api/music_api.dart';
import '../widgets/floating_music_player.dart';
import '../widgets/bottom_navbar.dart';
import 'music_player_page.dart';

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
    final fetchedSongs = await MusicApi().fetchSongs();
    setState(() {
      songs = fetchedSongs;
    });
  }

  void playSong(song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerPage(song: song),
      ),
    );
  }

  List<Widget> _pages() => [
        HomePageContent(
          songs: songs,
          onPlaySong: playSong,
        ),
        const Center(
            child: Text('Search Page', style: TextStyle(color: Colors.white))),
        const Center(
            child: Text('Library Page', style: TextStyle(color: Colors.white))),
        const Center(
            child: Text('Profile Page', style: TextStyle(color: Colors.white))),
      ];

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
              width: 359,
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
            const Text('Checkout the Latest Songs!',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 12),
            songs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return GestureDetector(
                        onTap: () => onPlaySong(song),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(song['thumbnail']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(song['title'],
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      Text(song['artist'],
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                              Text(song['duration'],
                                  style: const TextStyle(color: Colors.grey)),
                              const Icon(Icons.more_vert, color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
