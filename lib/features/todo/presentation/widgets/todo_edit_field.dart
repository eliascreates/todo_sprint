part of '../pages/todo_edit_page.dart';

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