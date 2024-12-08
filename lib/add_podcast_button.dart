import 'package:flutter/material.dart';
import 'add_podcast_dialog.dart';
import 'podcast.dart';

class AddPodcastButton extends StatelessWidget {
  final Function(Podcast) onPodcastAdded;

  const AddPodcastButton({Key? key, required this.onPodcastAdded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        final newPodcast = await showDialog<Podcast>(
          context: context,
          builder: (context) => const AddPodcastDialog(), // Now it's a widget
        );
        if (newPodcast != null) {
          onPodcastAdded(newPodcast);
        }
      },
    );
  }
}