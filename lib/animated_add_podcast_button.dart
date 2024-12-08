import 'package:flutter/material.dart';
import 'add_podcast_dialog.dart'; // Import add_podcast_dialog.dart
import 'podcast.dart';

class AnimatedAddPodcastButton extends StatefulWidget {
  final Function(Podcast) onPodcastAdded;

  const AnimatedAddPodcastButton({Key? key, required this.onPodcastAdded})
      : super(key: key);

  @override
  _AnimatedAddPodcastButtonState createState() =>
      _AnimatedAddPodcastButtonState();
}

class _AnimatedAddPodcastButtonState extends State<AnimatedAddPodcastButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          final newPodcast = await showDialog<Podcast>(
            context: context,
            builder: (context) => const AddPodcastDialog(),
          );
          if (newPodcast != null) {
            widget.onPodcastAdded(newPodcast);
          }
        },
        child: const Text('Add Podcast'),
      ),
    );
  }
}