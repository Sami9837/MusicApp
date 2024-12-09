import 'package:flutter/material.dart';
import 'package:music_apk/api/music_api.dart';
import 'package:music_apk/widgets/playlist_card.dart';
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
    final fetchedSongs = await MusicApi().fetchSongs();
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

  void playSong(dynamic song) {
    SongEntity songEntity = SongEntity(
      artist: song['artist'],
      title: song['title'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerPage(songEntity: songEntity),
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

MusicPlayerPage({required SongEntity songEntity}) {}

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
                                      Text(
                                        song['title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'kumbh Sans',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        song['artist'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'kumbh Sans',
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                243, 159, 89, 1)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                song['duration'],
                                style: const TextStyle(
                                  color: Color.fromRGBO(233, 188, 185, 1),
                                  fontFamily: 'KumbhSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                              const SizedBox(width: 40),
                              const Icon(Icons.more_vert, color: Colors.white),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
