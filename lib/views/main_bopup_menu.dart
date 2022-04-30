import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_galary_with_bloc/bloc/app_bloc.dart';
import 'package:photo_galary_with_bloc/bloc/app_event.dart';
import 'package:photo_galary_with_bloc/dialogs/delete_account_dailog.dart';
import 'package:photo_galary_with_bloc/dialogs/logout_dialog.dart';

enum MenuAction {
  logout,
  deleteAccount,
}

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final result = await showLogoutDailog(context);
            if (result) {
              context.read<AppBloc>().add(
                    const AppEventLogOut(),
                  );
            }
            return;
          case MenuAction.deleteAccount:
            final result = await showDeleteAccountDailog(context);
            if (result) {
              context.read<AppBloc>().add(
                    const AppEventDeleteAccount(),
                  );
            }
            return;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            child: Text('Delete Account'),
            value: MenuAction.deleteAccount,
          ),
          const PopupMenuItem<MenuAction>(
            child: Text('Log out'),
            value: MenuAction.logout,
          ),
        ];
      },
    );
  }
}
