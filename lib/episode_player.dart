import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class EpisodePlayer extends StatefulWidget {
  final String episodeUrl;

  const EpisodePlayer({Key? key, required this.episodeUrl}) : super(key: key);

  @override
  _EpisodePlayerState createState() => _EpisodePlayerState();
}

class _EpisodePlayerState extends State<EpisodePlayer> {
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  PlayerState? _playerState; // Make _playerState nullable

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _audioPlayer.setUrl(widget.episodeUrl);
      _audioPlayer.playerStateStream.listen((state) {
        setState(() {
          _playerState = state; // Update _playerState with the current state
          _isPlaying = state.playing;
        });

        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } catch (e) {
      print("Error loading audio: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load episode')),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
      onPressed: () {
        if (_playerState?.playing ?? false) { // Use null-aware operator and default to false
          _audioPlayer.pause();
        } else {
          _audioPlayer.play();
        }
      },
    );
  }
}