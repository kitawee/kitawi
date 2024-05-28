import 'package:views/views.dart';

View errorView(Object error, StackTrace? stackTrace) {
  return Reactive(
    builder: (view, update) {
      return Div(
        className:
            "w-[200px] h-[200px] shadow-lg flex items-center justify-center bg-gray-100 absolute top-0 left-0 right-0 bottom-0 m-auto z-50",
        children: [
          Div(
            className:
                "bg-white p-8 rounded-lg shadow-lg w-96 flex flex-col items-center border border-red-500 relative",
            children: [
              Div(
                className: "w-full flex flex-col",
                children: [
                  Div(
                    className: "w-full mb-2 flex flex-col items-center gap-4",
                    children: [
                      Text("Exception",
                          tag: "h1", className: "text-red-500 font-bold"),
                      Text("An error occurred: $error"),
                      Text("Stack trace: $stackTrace"),
                    ],
                  ),
                  Button(
                    className: "bg-red-500 text-white w-full py-2 rounded-md",
                    child: Text("Close"),
                    onPressed: (_) {
                      view.remove();
                    },
                  ),
                ],
              )
            ],
          )
        ],
      );
    },
    id: 'error-view',
  );
}
