// checkable_episode_item.dart
import 'package:flutter/material.dart';
import 'episode_player.dart';
import 'episode_completion_storage.dart';

class CheckableEpisodeItem extends StatefulWidget {
  final String title;
  final String? url;
  final String? subtitle;
  final String episodeId;
  final bool isCompleted;
  final Function() onCompletionChanged;

  const CheckableEpisodeItem({
    Key? key,
    required this.title,
    this.url,
    this.subtitle,
    required this.episodeId,
    required this.isCompleted,
    required this.onCompletionChanged,
  }) : super(key: key);

  @override
  State<CheckableEpisodeItem> createState() => _CheckableEpisodeItemState();
}

class _CheckableEpisodeItemState extends State<CheckableEpisodeItem> {

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
      title: Text(widget.title),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      trailing: widget.url != null && widget.url!.isNotEmpty
          ? EpisodePlayer(episodeUrl: widget.url!)
          : null,
    );
  }
}