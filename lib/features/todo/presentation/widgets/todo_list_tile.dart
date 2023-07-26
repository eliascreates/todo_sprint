import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile(
      {super.key,
      required this.todo,
      required this.onTap,
      this.onToggleComplete,
      this.onDismiss,
      this.popupItems});

  final Todo todo;
  final VoidCallback? onTap;
  final void Function(bool?)? onToggleComplete;
  final DismissDirectionCallback? onDismiss;
  final List<PopupMenuEntry<dynamic>>? popupItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Dismissible(
      key: UniqueKey(),
      onDismissed: onDismiss,
      direction: DismissDirection.endToStart,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          onTap: onTap,
          isThreeLine: true,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: Text(
            todo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: !todo.isCompleted
                ? null
                : TextStyle(
                    color: captionColor,
                    decoration: TextDecoration.lineThrough),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 10),
              const Divider(thickness: 1),
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 15),
                  const SizedBox(width: 10),
                  Text(
                    todo.formatDate(todo.dateUpdated),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              shape: const CircleBorder(),
              value: todo.isCompleted,
              onChanged: onToggleComplete,
            ),
          ),
          trailing: popupItems == null
              ? null
              : PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  itemBuilder: (context) => popupItems!,
                ),
        ),
      ),
    );
  }
}
