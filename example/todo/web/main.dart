import 'dart:js_interop_unsafe';

import 'package:view/view.dart';

void main() => Router.run(
      initialRoute: '/',
      debugMode: true,
      routes: [
        Route(
          path: '/',
          view: (p) => todoList(),
        ),
        Route(
          path: '/:id',
          afterRender: (params, [view]) {
            print(params);
            print(view?.element);
            view?.append(Text("Appended text"));
          },
          view: (p) => Div(
            children: [
              Text("Hello ${p['id']}"),
            ],
          ),
        ),
      ],
    );

List<String> todos = [];

View todoList() {
  String newTodo = "";

  return Reactive(
    builder: (view) {
      return Div(
        className: "min-h-screen bg-gray-100",
        children: [
          Div(
            className: "w-full flex justify-center",
            children: [
              Text("Todo List", className: "text-2xl"),
            ],
          ),

          // Add a new todo
          Div(
            className: "w-full flex flex-col justify-center items-center",
            children: [
              Div(
                className: "w-full md:w-2/3 lg:w-1/2 flex justify-center mt-4 ",
                children: [
                  TextInput(
                    value: newTodo,
                    onChanged: (p0) => newTodo = p0,
                    placeholder: "Add a new todo",
                    className: "w-1/2 p-2 border border-gray-300 rounded",
                    onSubmitted: (p0) {
                      if (newTodo.isEmpty) return;
                      todos.add(newTodo);
                      newTodo = "";
                      view.refresh();
                    },
                  ),
                  Button(
                    child: Text("Add"),
                    className: "ml-2 p-2 bg-blue-500 text-white rounded",
                    onPressed: (p0) {
                      if (newTodo.isEmpty) return;
                      todos.add(newTodo);
                      newTodo = "";
                      view.refresh();
                    },
                  ),
                ],
              ),
              Text(
                "Note: Press Enter to add a new todo!",
                className: "text-sm my-2",
              )
            ],
          ),

          // List of todos
          Div(
            className: "w-full mt-4 px-4   flex justify-center",
            children: [
              Div(
                className:
                    "w-full md:w-2/3 lg:w-1/3 p-2 border border-gray-300 rounded ",
                children: [
                  if (todos.isEmpty) Text("No todos found"),
                  for (var todo in todos)
                    Div(
                      className:
                          "flex justify-between items-center p-2 border-b border-gray-300",
                      children: [
                        Text(todo),
                        Button(
                          child: Text(
                            "Delete",
                          ),
                          className: "p-2 bg-red-500 text-white rounded",
                          onPressed: (p0) {
                            todos.remove(todo);
                            view.refresh();
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ],
      );
    },
    id: 'todo',
  );
}
