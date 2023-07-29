import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';

part 'todo_tab_state.dart';

enum TodoTab { all, complete, incomplete }

class TodoTabCubit extends Cubit<TodoTab> {
  final TabController tabController;

  TodoTabCubit({required this.tabController}) : super(TodoTab.all);

  void selectTab(TodoTab tab) {
    if (state != tab) {
      emit(tab);
      tabController.index = TodoTab.values.indexOf(tab);
    }
  }
}

