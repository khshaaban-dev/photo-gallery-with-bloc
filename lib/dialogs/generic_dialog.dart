import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T?>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: options.keys
          .map(
            (buttonText) => TextButton(
              onPressed: () {
                final value = options[buttonText];
                if (value != null) {
                  Navigator.pop(context, value);
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(buttonText),
            ),
          )
          .toList(),
    ),
  );
}
