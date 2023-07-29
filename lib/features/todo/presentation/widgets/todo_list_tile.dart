import 'package:flutter/material.dart';
import 'package:todo_sprint/core/constants/colors.dart';
import 'package:todo_sprint/core/constants/values.dart';

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
        margin: const EdgeInsets.all(Values.defaultPadding / 2),
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
          borderRadius: BorderRadius.circular(Values.defaultPadding),
        ),
        child: ListTile(
          onTap: onTap,
          isThreeLine: true,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(Values.defaultPadding * 1.5)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Values.defaultPadding / 2,
          ),
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
              const SizedBox(width: Values.defaultPadding / 2),
              const Divider(thickness: 1),
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 15),
                  const SizedBox(width: Values.defaultPadding / 2),
                  Text(
                    todo.formatUpdatedDate(),
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
              activeColor: AppColors.lSecondaryColor,
              value: todo.isCompleted,
              onChanged: onToggleComplete,
            ),
          ),
          trailing: popupItems == null
              ? null
              : PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Values.defaultPadding)),
                  itemBuilder: (context) => popupItems!,
                ),
        ),
      ),
    );
  }
}
