import 'dart:async';

import 'package:view/src/basic.dart';
import 'package:view/src/style.dart';
import 'package:web/web.dart' as web;

class Dialog {
  static bool isOpen = false;

  static late View _openDialog;

  /// Show a dialog box
  ///
  /// Note: Only a single dialog box can be shown at a time
  static void show(
    View view, {
    String? className,
    String? id,
    String? width = "calc(100% * 0.3)",
    bool persistent = false,
  }) {
    if (isOpen) {
      close();
    }

    final dialogDiv = Div(
      onClick: (p0) {
        if (!persistent) close();
      },
      className: className ??
          "absolute w-full h-full  inset-0 bg-black bg-opacity-50 z-50",
      children: [
        Div(className: "flex justify-center items-center h-full", children: [
          Div(
            onClick: (event) => event.stopPropagation(),
            className: "bg-white p-4 rounded-lg",
            style: Style(width: width),
            children: [
              view,
            ],
          ),
        ])
      ],
    );

    // append the dialog div to the body
    web.document.body!.append(dialogDiv.render());
    isOpen = true;
    _openDialog = dialogDiv;
  }

  /// Close the dialog box
  static void close() {
    if (isOpen) {
      _openDialog.remove();
      isOpen = false;
    }
  }
}

enum ToastType { success, error, warning, info }

enum ToastPosition {
  top,
  bottom,
  center,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  centerLeft,
  centerRight
}

class Toast {
  static Future<void> show(
    View view, {
    ToastType type = ToastType.info,
    ToastPosition position = ToastPosition.bottomRight,
    int duration = 3000,
    String? bgColor,
    String? className,
  }) async {
    if (bgColor == null) {
      switch (type) {
        case ToastType.success:
          bgColor = "bg-green-500";
          break;
        case ToastType.error:
          bgColor = "bg-red-500";
          break;
        case ToastType.warning:
          bgColor = "bg-yellow-500";
          break;
        case ToastType.info:
          bgColor = "bg-blue-500";
          break;
      }
    }

    String positionClass = "";
    switch (position) {
      case ToastPosition.top:
        positionClass = "top-0";
        break;
      case ToastPosition.bottom:
        positionClass = "bottom-0";
        break;
      case ToastPosition.center:
        positionClass =
            "top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2";
        break;
      case ToastPosition.topLeft:
        positionClass = "top-0 left-0";
        break;
      case ToastPosition.topRight:
        positionClass = "top-0 right-0";
        break;
      case ToastPosition.bottomLeft:
        positionClass = "bottom-0 left-0";
        break;
      case ToastPosition.bottomRight:
        positionClass = "bottom-0 right-0";
        break;
      case ToastPosition.centerLeft:
        positionClass = "top-1/2 left-0 transform -translate-y-1/2";
        break;
      case ToastPosition.centerRight:
        positionClass = "top-1/2 right-0 transform -translate-y-1/2";
        break;
    }

    final toastContainer = Div(
      className:
          "fixed z-50 $positionClass p-4 $bgColor rounded-md $className m-2",
      children: [
        view,
      ],
    );

    web.document.body!.append(toastContainer.render());

    final completer = Completer<void>();

    Timer(Duration(milliseconds: duration), () {
      toastContainer.remove();
      completer.complete();
    });

    return completer.future;
  }
}

// class DatePicker {
//   static void show({
//     required DateTime initialDate,
//     required void Function(DateTime) onDateSelected,
//   }) {
//     final datePicker = Div(
//       className: "bg-white p-4 rounded-lg",
//       children: [
//         Text("Select a date"),
//         Div(
//           className: "flex gap-2",
//           children: [
//             Button(
//               child: Text("Cancel"),
//               onPressed: (v) {
//                 Dialog.close();
//               },
//             ),
//             Button(
//               child: Text("Select"),
//               onPressed: (v) {
//                 onDateSelected(DateTime.now());
//                 Dialog.close();
//               },
//             ),
//           ],
//         ),
//       ],
//     );

//     Dialog.show(datePicker);
//   }
// }