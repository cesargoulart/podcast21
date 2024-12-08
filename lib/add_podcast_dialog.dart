import 'package:flutter/material.dart';
import 'podcast.dart';

class AddPodcastDialog extends StatefulWidget {
  const AddPodcastDialog({Key? key}) : super(key: key);

  @override
  _AddPodcastDialogState createState() => _AddPodcastDialogState();
}

class _AddPodcastDialogState extends State<AddPodcastDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feedController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    feedController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a new podcast'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: feedController,
              decoration: const InputDecoration(
                labelText: 'Feed',
              ),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Return null (canceled)
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newPodcast = Podcast(
              name: nameController.text,
              feed: feedController.text,
              imageUrl: imageController.text,
            );
            Navigator.pop(context, newPodcast); // Return the new podcast
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}