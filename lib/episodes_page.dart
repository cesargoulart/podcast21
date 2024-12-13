// episodes_page.dart
import 'package:flutter/material.dart';
import 'podcast.dart';
import 'rss_parser.dart';
import 'completed_episode_item.dart';
import 'completion_toggle_button.dart';
import 'episode_completion_storage.dart';

class EpisodesPage extends StatefulWidget {
  final Podcast podcast;

  const EpisodesPage({Key? key, required this.podcast}) : super(key: key);

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  Set<String> completedEpisodes = {};
  bool showCompleted = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedEpisodes();
  }

  Future<void> _loadCompletedEpisodes() async {
    final completed = await EpisodeCompletionStorage.loadCompletedEpisodes();
    setState(() {
      completedEpisodes = completed;
    });
  }

  String _generateEpisodeId(String title, String podcastName) {
    return '$podcastName-$title';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.podcast.name),
        actions: [
          CompletionToggleButton(
            showCompleted: showCompleted,
            onToggle: (show) {
              setState(() {
                showCompleted = show;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: RssParser.fetchEpisodes(widget.podcast.feed),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No episodes found.'));
          }

          final episodes = snapshot.data!;
          final filteredEpisodes = episodes.where((episode) {
            final episodeId = _generateEpisodeId(
              episode['title'] ?? '',
              widget.podcast.name,
            );
            final isCompleted = completedEpisodes.contains(episodeId);
            return showCompleted || !isCompleted;
          }).toList();

          return ListView.builder(
            itemCount: filteredEpisodes.length,
            itemBuilder: (context, index) {
              final episode = filteredEpisodes[index];
              final episodeTitle = episode['title'] ?? 'Untitled Episode';
              final episodeUrl = episode['url'] ?? '';
              final episodeId = _generateEpisodeId(
                episodeTitle,
                widget.podcast.name,
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.blue.shade50,
                child: CompletedEpisodeItem(
                  title: episodeTitle,
                  url: episodeUrl,
                  episodeId: episodeId,
                  isCompleted: completedEpisodes.contains(episodeId),
                  onCompletionChanged: _loadCompletedEpisodes,
                ),
              );
            },
          );
        },
      ),
    );
  }
}