import 'package:flutter/cupertino.dart';
import 'package:photo_galary_with_bloc/auth/auth_error.dart';
import 'package:photo_galary_with_bloc/dialogs/generic_dialog.dart';

// auth error  dialog
Future<void> showAuthErrorDailog({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {
      'OK': true,
    },
  );
}
