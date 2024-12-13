import 'package:flutter/material.dart';
import 'package:podcast/recent_episodes_page.dart';
import 'podcast.dart';
import 'episodes_page.dart';
import 'animated_add_podcast_button.dart';
import 'podcast_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final List<Podcast> _podcasts = [];

  @override
  void initState() {
    super.initState();
    _loadPodcasts();
  }

  Future<void> _loadPodcasts() async {
    final loadedPodcasts = await PodcastStorage.loadPodcasts();
    setState(() {
      _podcasts.clear();
      _podcasts.addAll(loadedPodcasts);
    });
  }

  Future<void> _addPodcast(Podcast podcast) async {
    setState(() {
      _podcasts.add(podcast);
    });
    await PodcastStorage.savePodcasts(_podcasts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Podcast Home'),
        actions: [
          RecentEpisodesButton(podcasts: _podcasts),
          AnimatedAddPodcastButton(onPodcastAdded: _addPodcast),
        ],
      ),
      body: _podcasts.isEmpty
          ? const Center(child: Text('No podcasts yet, add one!'))
          : GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _podcasts.length,
              itemBuilder: (context, index) {
                final podcast = _podcasts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EpisodesPage(podcast: podcast),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 1,
                    margin: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: podcast.imageUrl.isNotEmpty
                              ? Image.network(
                                  podcast.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Image loading failed: $error");
                                    return const Icon(
                                      Icons.podcasts,
                                      size: 32,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.podcasts,
                                  size: 32,
                                ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              podcast.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
