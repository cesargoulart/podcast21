// completed_episode_item.dart
import 'package:flutter/material.dart';
import 'episode_player.dart';
import 'episode_completion_storage.dart';

class CompletedEpisodeItem extends StatefulWidget {
  final String title;
  final String? url;
  final String? subtitle;
  final String episodeId;
  final bool isCompleted;
  final Function() onCompletionChanged;

  const CompletedEpisodeItem({
    Key? key,
    required this.title,
    this.url,
    this.subtitle,
    required this.episodeId,
    required this.isCompleted,
    required this.onCompletionChanged,
  }) : super(key: key);

  @override
  State<CompletedEpisodeItem> createState() => _CompletedEpisodeItemState();
}

class _CompletedEpisodeItemState extends State<CompletedEpisodeItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.isCompleted,
        onChanged: (bool? value) async {
          if (value ?? false) {
            await EpisodeCompletionStorage.markEpisodeAsCompleted(widget.episodeId);
          } else {
            await EpisodeCompletionStorage.markEpisodeAsUncompleted(widget.episodeId);
          }
          widget.onCompletionChanged();
        },
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          decoration: widget.isCompleted ? TextDecoration.lineThrough : null,
          color: widget.isCompleted ? Colors.grey : null,
        ),
      ),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      trailing: widget.url != null && widget.url!.isNotEmpty
          ? EpisodePlayer(episodeUrl: widget.url!)
          : null,
    );
  }
}