import 'package:flutter/material.dart';
import 'podcast.dart';
import 'episodes_page.dart';
import 'animated_add_podcast_button.dart'; // Import the new button

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Podcast App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Podcast> _podcasts = [
    Podcast(
      name: 'My Podcast',
      feed: 'https://www.website.com/podcast.rss',
      imageUrl: 'https://www.website.com/image.jpg',
    ),
  ];

  void _addPodcast(Podcast podcast) {
    setState(() {
      _podcasts.add(podcast);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Podcast Home'),
        actions: [
          AnimatedAddPodcastButton(onPodcastAdded: _addPodcast), // Use the new animated button
        ],
      ),
      body: _podcasts.isEmpty
          ? const Center(child: Text('No podcasts yet, add one!'))
          : ListView.builder(
              itemCount: _podcasts.length,
              itemBuilder: (context, index) {
                final podcast = _podcasts[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: podcast.imageUrl.isNotEmpty
                        ? Image.network(
                            podcast.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print("Image loading failed: $error");
                              return const Icon(Icons.podcasts);
                            },
                          )
                        : const Icon(Icons.podcasts),
                    title: Text(podcast.name),
                    subtitle: Text(podcast.feed),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EpisodesPage(podcast: podcast),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}