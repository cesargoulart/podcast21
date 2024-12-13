// completion_toggle_button.dart
import 'package:flutter/material.dart';

class CompletionToggleButton extends StatelessWidget {
  final bool showCompleted;
  final Function(bool) onToggle;

  const CompletionToggleButton({
    Key? key,
    required this.showCompleted,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        showCompleted ? Icons.visibility : Icons.visibility_off,
        color: showCompleted ? Colors.blue : Colors.grey,
      ),
      tooltip: showCompleted ? 'Hide completed' : 'Show completed',
      onPressed: () {
        onToggle(!showCompleted);
      },
    );
  }
}