import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/core/constants/strings.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:uuid/uuid.dart';

import '../bloc/todo_bloc.dart';

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
  String title = '', description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.todo != null
              ? Strings.todoAddAppBarTitle
              : Strings.todoEditAppBarTitle,
        ),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 2)),
                      ]),
                  child: Column(
                    children: [
                      _TitleField(
                        _titleController,
                        todo: widget.todo,
                        onChanged: (text) {
                          title = text;
                        },
                      ),
                      _DescriptionField(
                        _descriptionController,
                        todo: widget.todo,
                        onChanged: (text) {
                          description = text;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (widget.todo == null) {
                      final newDate = DateTime.now().toIso8601String();
                      final newTodo = Todo(
                        id: const Uuid().v1(),
                        title: title,
                        description: description,
                        dateCreated: newDate,
                        dateUpdated: newDate,
                      );
                      context.read<TodoBloc>().add(TodoCreated(todo: newTodo));
                      _descriptionController.clear();
                      _titleController.clear();

                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  child: Text(widget.todo != null ? "UPDATE" : "CREATE"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField(this.controller, {required this.todo, this.onChanged});
  final Todo? todo;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      controller: controller,
      initialValue: todo?.title,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'TITLE',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField(this.controller,
      {required this.todo, this.onChanged});
  final Todo? todo;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      controller: controller,
      initialValue: todo?.description,
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: 'DESCRIPTION',
        enabled: true,
      ),
      maxLength: 300,
      maxLines: 20,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
    );
  }
}
