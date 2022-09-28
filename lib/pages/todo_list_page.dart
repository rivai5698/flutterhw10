import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo_model.dart';
import '../provider/todo_list_provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  TodoModel? _todoModel;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          Consumer(
            builder: (_, TodoListProvider todoListProvider, __) {
              if (todoListProvider.currentStatus == Status.creating) {
                return const SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              }
              return IconButton(
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    context
                        .read<TodoListProvider>()
                        .createNewTodo(_textEditingController.text);
                    _textEditingController.text = '';
                  }
                },
                icon: const Icon(Icons.add),
              );
            },
          ),
          Consumer(builder: (_, TodoListProvider todoListProvider, __) {
            if (todoListProvider.currentStatus == Status.removing) {
              return const SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            }
            return IconButton(
              onPressed: () {
                if (_todoModel != null) {
                  context.read<TodoListProvider>().onRemove(_todoModel!);
                }
              },
              icon: const Icon(Icons.remove),
            );
          }),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Input to do',
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (_, TodoListProvider todoListProvider, __) {
                  return ListView.separated(
                    itemCount: todoListProvider.listTodos.length,
                    itemBuilder: (_, index) {
                      return _itemWidget(
                          todoListProvider.listTodos[index], todoListProvider);
                    },
                    separatorBuilder: (_, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemWidget(TodoModel todoModel, TodoListProvider todoListProvider) {
    return InkWell(
      onTap: () {
        if (_todoModel?.dateTime == todoModel.dateTime) {
          _todoModel == null;
        } else {
          _todoModel = todoModel;
        }
        todoListProvider.onUpdate();
      },
      child: Container(
        decoration: BoxDecoration(
          color: todoModel.dateTime == _todoModel?.dateTime
              ? Colors.redAccent
              : Colors.grey,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(todoModel.name),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  DateTime.fromMicrosecondsSinceEpoch(todoModel.dateTime)
                      .toString()),
            ),
          ],
        ),
      ),
    );
  }
}
