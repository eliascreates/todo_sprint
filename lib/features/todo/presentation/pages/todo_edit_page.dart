import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/core/constants/strings.dart';
import 'package:todo_sprint/core/constants/values.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

import '../bloc/todo_bloc.dart';

part '../widgets/todo_edit_fields.dart';

class TodoEditPage extends StatelessWidget {
  const TodoEditPage({super.key, this.todo});

  final Todo? todo;

  @override
  Widget build(BuildContext context) {
    return TodoEditView(todo: todo);
  }
}

class TodoEditView extends StatefulWidget {
  const TodoEditView({super.key, this.todo});
  final Todo? todo;

  @override
  State<TodoEditView> createState() => _TodoEditViewState();
}

class _TodoEditViewState extends State<TodoEditView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? title, description;

  @override
  Widget build(BuildContext context) {
    bool isNotEmpty = widget.todo != null;

    if (isNotEmpty) {
      _titleController.text = widget.todo?.title ?? '';
      _descriptionController.text = widget.todo?.description ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNotEmpty ? Strings.todoEditAppBarTitle : Strings.todoAddAppBarTitle,
        ),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Values.defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Values.defaultPadding),
                Container(
                  padding: const EdgeInsets.all(Values.defaultPadding / 2),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                  child: Column(
                    children: [
                      _TitleField(
                        _titleController,
                        todo: widget.todo,
                        onChanged: (text) => title = text,
                      ),
                      _DescriptionField(
                        _descriptionController,
                        todo: widget.todo,
                        onChanged: (text) => description = text,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Values.defaultPadding),
                ElevatedButton(
                  onPressed: () {
                    if (widget.todo case final todo?) {
                      context.read<TodoBloc>().add(
                            TodoUpdated(
                              todoId: todo.id,
                              title: title,
                              description: description,
                            ),
                          );
                    } else {
                      context.read<TodoBloc>().add(
                            TodoCreated(
                              title: title ?? '',
                              description: description ?? '',
                            ),
                          );
                      _descriptionController.clear();
                      _titleController.clear();
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  child: Text(
                    isNotEmpty
                        ? Strings.todoButtonUpdateLabel
                        : Strings.todoButtonCreateLabel,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
