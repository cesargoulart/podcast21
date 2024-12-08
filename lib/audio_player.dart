import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      print('Attempting to play URL: ${widget.url}');
      await _player.setUrl(widget.url);
      await _player.play();
    } catch (e) {
      print("Error playing audio: $e");
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play episode')),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You can build a more elaborate UI here, such as adding playback controls
    return Icon(Icons.play_arrow);
  }
}