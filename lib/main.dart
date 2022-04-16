import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/boxes.dart';

import 'model/todo.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init Hive, register Adapter and open box named 'todos'
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  await Hive.openBox<ToDo>('todos');

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TodoApp(),
  ));
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _controller = TextEditingController();
  int _index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Qaydnoma',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: ValueListenableBuilder<Box<ToDo>>(
              valueListenable: Boxes.getToDos().listenable(),
              builder: (context, box, _) {
                final todos = box.values.toList().cast<ToDo>();
                return buildContent(todos);
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              separatorBuilder: (_, __) => const SizedBox(
                width: 32,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      print(index);
                      _index = index;
                      print(_index);
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: _colors.elementAt(index),
                  ),
                );
              },
            ),
          ),
          Stack(
            children: [
              Positioned(
                bottom: 20,
                right: 12,
                child: InkWell(
                  onTap: () async {
                    addToDo(_controller.text, _index, false);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.zero,
                          bottomLeft: Radius.zero,
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                    ),
                    width: 60,
                    height: 59,
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, bottom: 20.0, right: 70),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16))),
                  ),
                ),
              ),
            ],
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

List<Color> _colors = <Color>[
  Colors.green,
  Colors.redAccent,
  Colors.yellowAccent,
  Colors.blue,
  Colors.orangeAccent
];
Future addToDo(String title, int colorIndex, bool isCompleted) async {
  final todo =
      ToDo(title: title, colorNumber: colorIndex, completed: isCompleted);
  final box = Boxes.getToDos();
  if (title.isNotEmpty) {
    box.add(todo);
  }
}

Widget buildContent(List<ToDo> todos) {
  if (todos.isEmpty) {
    return const Center(
      child: Text(
        'No todos yet!',
        style: TextStyle(fontSize: 24),
      ),
    );
  } else {
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = todos[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  height: 60,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: _colors.elementAt(todo.colorNumber)),
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Text(
                          todo.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: Colors.green.withOpacity(0.7),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 50,
                        ),
                        width: 60,
                        height: 60,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
