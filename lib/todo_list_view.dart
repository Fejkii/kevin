import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:kevin/bloc/auth/auth_bloc.dart';
import 'package:kevin/models/todo_model.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  final TextEditingController titleController = TextEditingController();
  bool isChecked = false;
  final todoQuery = FirebaseFirestore.instance.collection("todos");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO list"),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is LoggedInState) {
            return Column(
              children: [
                Text("Jméno: ${state.userModel.userName}"),
                Text("Email: ${state.userModel.email}"),
                FloatingActionButton(
                  tooltip: "Add Todo",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildPopupDialog(context),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                FirestoreListView(
                  shrinkWrap: true,
                  query: todoQuery,
                  itemBuilder: ((context, doc) {
                    if (!doc.exists) {
                      return const Text("Nic tu neni");
                    }
                    final String? todoTitle = doc.get("title");
                    final bool? todoIsDone = doc.get("isDone");
                    if (todoTitle != null && todoIsDone != null) {
                      TodoModel todoModel = TodoModel(todoTitle, todoIsDone);
                      return Row(
                        children: [
                          Text(todoModel.title),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(todoModel.isDone ? "Ano" : "Ne"),
                        ],
                      );
                    } else {
                      return const Text("Nic tu neni");
                    }
                  }),
                ),
                const Text("Test 2"),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(const LogOutEvent());
                  },
                  child: const Text("Odhlásit"),
                ),
              ],
            );
          } else {
            return Center(
              child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(const LogInEvent(email: "test", password: "heslo"));
                  },
                  child: const Text("Přihlásit")),
            );
          }
        },
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return AlertDialog(
      title: const Text('Popup example'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              label: Text("Title"),
            ),
          ),
          Row(
            children: [
              const Text("Is done"),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            todoQuery.add({
              "title": titleController.text,
              "isDone": isChecked,
            });
            Navigator.of(context).pop();
            titleController.text = "";
            isChecked = false;
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
