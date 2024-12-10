import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class AppURLs {
  static const songAPI = 'https://task-4-0pfy.onrender.com/songs/';
  static const coverAPI = 'https://task-4-0pfy.onrender.com/songs/';
}

class AppColors {
  static const primary = Colors.blue;
}

class SongEntity {
  final String artist;
  final String title;

  SongEntity({required this.artist, required this.title});
}

abstract class SongPlayerState {}

class SongPlayerInitial extends SongPlayerState {}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {}

class SongPlayerError extends SongPlayerState {}

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration songPosition = Duration.zero;
  Duration songDuration = Duration.zero;

  SongPlayerCubit() : super(SongPlayerInitial());

  Future<void> loadSong(String url) async {
    emit(SongPlayerLoading());
    try {
      await audioPlayer.setUrl(url);
      audioPlayer.positionStream.listen((position) {
        songPosition = position;
        emit(SongPlayerLoaded());
      });
      audioPlayer.durationStream.listen((duration) {
        songDuration = duration ?? Duration.zero;
        emit(SongPlayerLoaded());
      });
    } catch (e) {
      emit(SongPlayerError());
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }
}

class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;

  const FavoriteButton({required this.songEntity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.favorite_border),
      onPressed: () {},
    );
  }
}

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;

  const SongPlayerPage({required this.songEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Now playing',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()
          ..loadSong(
              '${AppURLs.songAPI}${songEntity.artist}/${songEntity.title}.mp3'),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  _songCover(context),
                  const SizedBox(height: 20),
                  _songDetail(),
                  const SizedBox(height: 30),
                  _songPlayer(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '${AppURLs.coverAPI}${songEntity.artist}/${songEntity.title}.jpg',
          ),
        ),
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 5),
            Text(
              songEntity.artist,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ],
        ),
        FavoriteButton(songEntity: songEntity),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const CircularProgressIndicator();
        }
        if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                value: context
                    .read<SongPlayerCubit>()
                    .songPosition
                    .inSeconds
                    .toDouble(),
                min: 0.0,
                max: context
                    .read<SongPlayerCubit>()
                    .songDuration
                    .inSeconds
                    .toDouble(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(
                      context.read<SongPlayerCubit>().songPosition)),
                  Text(formatDuration(
                      context.read<SongPlayerCubit>().songDuration)),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  context.read<SongPlayerCubit>().playOrPauseSong();
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(
                    context.read<SongPlayerCubit>().audioPlayer.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

void main() {
  runApp(MaterialApp(
    home: SongPlayerPage(
      songEntity: SongEntity(artist: "ArtistName", title: "SongTitle"),
    ),
  ));
}
