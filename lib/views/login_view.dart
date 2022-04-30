import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_galary_with_bloc/bloc/app_bloc.dart';
import 'package:photo_galary_with_bloc/bloc/app_event.dart';
import 'package:photo_galary_with_bloc/extensions/if_debuging.dart';

class LogInView extends HookWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: 'hbmohamed89@gmail.com'.ifDebuging,
    );
    final passwordController = useTextEditingController(
      text: 'foobarbaz'.ifDebuging,
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('login'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration:
                    const InputDecoration(hintText: 'Inter your email '),
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Inter your password',
                ),
                keyboardAppearance: Brightness.dark,
                obscureText: true,
                obscuringCharacter: '⚫',
              ),
              TextButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  context.read<AppBloc>().add(
                        AppEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(
                        const AppEventGoToRegistration(),
                      );
                },
                child: const Text(
                  'Have not account ? Regiser now...',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
