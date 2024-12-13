// episode_completion_storage.dart
import 'dart:convert';
import 'dart:io';

class EpisodeCompletionStorage {
  static const String completedEpisodesFile = 'completed_episodes.json';

  static Future<Set<String>> loadCompletedEpisodes() async {
    try {
      final file = File(completedEpisodesFile);
      if (!await file.exists()) {
        return {};
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<String>().toSet();
    } catch (e) {
      print('Error loading completed episodes: $e');
      return {};
    }
  }

  static Future<void> saveCompletedEpisodes(Set<String> completedEpisodes) async {
    try {
      final file = File(completedEpisodesFile);
      final jsonString = json.encode(completedEpisodes.toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving completed episodes: $e');
    }
  }

  static Future<void> markEpisodeAsCompleted(String episodeId) async {
    final completed = await loadCompletedEpisodes();
    completed.add(episodeId);
    await saveCompletedEpisodes(completed);
  }

  static Future<void> markEpisodeAsUncompleted(String episodeId) async {
    final completed = await loadCompletedEpisodes();
    completed.remove(episodeId);
    await saveCompletedEpisodes(completed);
  }
}