import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    super.key,
    required this.todo,
    required this.onTap,
    this.onToggleComplete,
    this.onDismiss,
  });

  final Todo todo;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleComplete;
  final DismissDirectionCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Dismissible(
      key: Key('todoListTile_dismissible_${todo.id}'),
      onDismissed: onDismiss,
      direction: DismissDirection.endToStart,
      child: ListTile(
        onTap: onTap,
        title: Text(
          todo.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: !todo.isCompleted
              ? null
              : TextStyle(
                  color: captionColor, decoration: TextDecoration.lineThrough),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.calendar_month, size: 15),
            const SizedBox(width: 10),
            Text(
              todo.formatDate(todo.dateUpdated).substring(3),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: Checkbox(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          value: todo.isCompleted,
          onChanged: (value) => value,
        ),
        trailing: PopupMenuButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            itemBuilder: (context) => [
                  const PopupMenuItem(
                      child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 20),
                      Text('Edit'),
                    ],
                  )),
                  const PopupMenuItem(
                      child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 20),
                      Text('Delete'),
                    ],
                  )),
                ]),
      ),
    );
  }
}
