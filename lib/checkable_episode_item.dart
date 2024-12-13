// checkable_episode_item.dart
import 'package:flutter/material.dart';
import 'episode_player.dart';

class CheckableEpisodeItem extends StatefulWidget {
  final String title;
  final String? url;
  final String? subtitle;
  final Function(bool)? onCheckChanged;

  const CheckableEpisodeItem({
    Key? key,
    required this.title,
    this.url,
    this.subtitle,
    this.onCheckChanged,
  }) : super(key: key);

  @override
  State<CheckableEpisodeItem> createState() => _CheckableEpisodeItemState();
}

class _CheckableEpisodeItemState extends State<CheckableEpisodeItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value ?? false;
          });
          if (widget.onCheckChanged != null) {
            widget.onCheckChanged!(isChecked);
          }
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