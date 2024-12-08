import 'package:flutter/material.dart';
import 'podcast.dart';
import 'rss_parser.dart';
import 'episode_player.dart'; // Import the new player

class EpisodesPage extends StatefulWidget {
  final Podcast podcast;

  const EpisodesPage({Key? key, required this.podcast}) : super(key: key);

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.podcast.name),
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
          return ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final episode = episodes[index];
              final episodeTitle = episode['title'];
              final episodeUrl = episode['url'];

              return ListTile(
                title: Text(episodeTitle ?? 'Untitled Episode'),
                trailing: episodeUrl != null && episodeUrl.isNotEmpty
                    ? EpisodePlayer(episodeUrl: episodeUrl)
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}