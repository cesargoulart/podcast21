import 'package:flutter/material.dart';
import 'package:podcast/checkable_episode_item.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'episode_player.dart';
import 'podcast.dart';
import 'episode_completion_storage.dart';

class RecentEpisodesPage extends StatefulWidget {
  final List<Podcast> podcasts;

  const RecentEpisodesPage({Key? key, required this.podcasts}) : super(key: key);

  @override
  State<RecentEpisodesPage> createState() => _RecentEpisodesPageState();
}

class _RecentEpisodesPageState extends State<RecentEpisodesPage> {
  Set<String> completedEpisodes = {};

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Episodes'),
      ),
      body: FutureBuilder<List<EpisodeInfo>>(
        future: _fetchRecentEpisodes(widget.podcasts),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recent episodes found'));
          }

          final episodes = snapshot.data!;
          return ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final episode = episodes[index];
                final episodeId = _generateEpisodeId(episode.title, episode.podcastName);
                final isCompleted = completedEpisodes.contains(episodeId);
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.blue.shade50, // Light blue background
                  child: CheckableEpisodeItem(
                    title: episode.title,
                    subtitle: '${episode.podcastName} - ${episode.pubDate}',
                    url: episode.url,
                    episodeId: episodeId,
                    isCompleted: isCompleted,
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

class EpisodeInfo {
  final String title;
  final String url;
  final DateTime pubDate;
  final String podcastName;

  EpisodeInfo({
    required this.title,
    required this.url,
    required this.pubDate,
    required this.podcastName,
  });
}

String _generateEpisodeId(String title, String podcastName) {
  return '$podcastName-$title';
}

Future<List<EpisodeInfo>> _fetchRecentEpisodes(List<Podcast> podcasts) async {
  final fiveDaysAgo = DateTime.now().subtract(const Duration(days: 5));
  final allEpisodes = <EpisodeInfo>[];
  final completedEpisodes = await EpisodeCompletionStorage.loadCompletedEpisodes();

  for (final podcast in podcasts) {
    try {
      final response = await http.get(Uri.parse(podcast.feed));
      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final items = document.findAllElements('item');

        for (final item in items) {
          final pubDateStr = item.findElements('pubDate').firstOrNull?.text;
          if (pubDateStr == null) continue;

          DateTime? pubDate;
          try {
            pubDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(pubDateStr);
          } catch (e) {
            try {
              pubDate = DateTime.parse(pubDateStr);
            } catch (e) {
              continue;
            }
          }

          if (pubDate.isAfter(fiveDaysAgo)) {
            final title = item.findElements('title').firstOrNull?.text ?? 'Untitled';
            final enclosure = item.findElements('enclosure').firstOrNull;
            final url = enclosure?.getAttribute('url') ?? '';
            final episodeId = _generateEpisodeId(title, podcast.name);


            allEpisodes.add(EpisodeInfo(
              title: title,
              url: url,
              pubDate: pubDate,
              podcastName: podcast.name,
            ));
          }
        }
      }
    } catch (e) {
      print('Error fetching episodes for ${podcast.name}: $e');
    }
  }

  // Sort episodes by publication date (newest first)
  allEpisodes.sort((a, b) => b.pubDate.compareTo(a.pubDate));
  return allEpisodes;
}

// Add this button to your MyHomePage class
class RecentEpisodesButton extends StatelessWidget {
  final List<Podcast> podcasts;

  const RecentEpisodesButton({Key? key, required this.podcasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.access_time),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecentEpisodesPage(podcasts: podcasts),
          ),
        );
      },
      tooltip: 'Recent Episodes',
    );
  }
}
