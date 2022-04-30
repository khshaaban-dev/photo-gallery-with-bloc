import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_galary_with_bloc/bloc/app_event.dart';
import 'package:photo_galary_with_bloc/dialogs/show_auth_error.dart';
import 'package:photo_galary_with_bloc/loading/loading_screen.dart';
import 'package:photo_galary_with_bloc/views/photo_gallery_view.dart';
import 'package:photo_galary_with_bloc/views/register_view.dart';

import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import 'login_view.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            if (appState.authError != null) {
              showAuthErrorDailog(
                authError: appState.authError!,
                context: context,
              );
            }
          },
          builder: (_, appState) {
            if (appState is AppStateLoggedOut) {
              return const LogInView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else {
              return const SizedBox(
                child: Text('Error'),
              );
            }
          },
        ),
      ),
    );
  }
}
