import 'package:flutter/material.dart';
import 'package:flutterhw10/model/todo_model.dart';

class TodoListProvider extends ChangeNotifier{
  List<TodoModel> listTodos = [];
  Status currentStatus = Status.init;
  Future<void> createNewTodo(String name) async {
      currentStatus = Status.creating;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      int dateTime = DateTime.now().millisecondsSinceEpoch;
      TodoModel todoModel = TodoModel(name, dateTime);
      listTodos.add(todoModel);
      currentStatus = Status.created;
      notifyListeners();
  }

  Future<void> onRemove(TodoModel todoModel) async {
    currentStatus = Status.removing;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    listTodos.removeWhere((element) => element.dateTime == todoModel.dateTime);
    currentStatus = Status.removed;
    notifyListeners();
  }



  void onUpdate(){
    notifyListeners();
  }

}

enum Status{
  init,
  creating,
  created,
  removing,
  removed,
}