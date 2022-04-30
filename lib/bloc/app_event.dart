import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

// event for upload image
class AppEventUploadImage implements AppEvent {
  // image path
  final String filePathToUpload;
  const AppEventUploadImage({required this.filePathToUpload});
}

// event for delete account
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

// event for log out
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

// event for initialize
//( when the user log out for example this event fires to make bloc emit initiale state )
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

// event for send login info
class AppEventLogIn implements AppEvent {
  final String email;
  final String password;
  const AppEventLogIn(
    this.email,
    this.password,
  );
}

// event for send register info
class AppEventRegister implements AppEvent {
  final String email;
  final String password;
  const AppEventRegister(
    this.email,
    this.password,
  );
}

// event to navigate to registre widget or screen
class AppEventGoToRegistration implements AppEvent {
  const AppEventGoToRegistration();
}

// event to navigate to logIn widget or screen
class AppEventGoToLogIn implements AppEvent {
  const AppEventGoToLogIn();
}
