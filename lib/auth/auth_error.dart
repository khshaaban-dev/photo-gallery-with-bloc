import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMaping = {
  'user-not-found': AuthErrorNoCurrentUser(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'operation-not-allowed': AuthErrorOprationNotAllowed(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
  'fialed-to-upload-image': UploadImageError(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;
  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });
  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMaping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnkown();
}

// this error is coustom error and used to handle upload images errors
@immutable
class UploadImageError extends AuthError {
  const UploadImageError()
      : super(
          dialogTitle: 'Fail to upload image',
          dialogText: 'Check your connection or try in anther time!',
        );
}

// for any error not known
@immutable
class AuthErrorUnkown extends AuthError {
  const AuthErrorUnkown()
      : super(
          dialogTitle: 'Unkown authentication error',
          dialogText: 'Authentaication error',
        );
}

//auth/no-current-user
// for any opration that the user is not found
@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: 'No current user',
          dialogText: 'No current user with this information was found',
        );
}

// auth/requires-recent-login
// when the user take long while from the last login he mast log out and login again
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: 'Requires recent login',
          dialogText:
              'You need to log out and log back in again in order to perform this opration',
        );
}

// auth/operation-not-allowed
// when the usre try to sign in with method you have not allowed to this app
@immutable
class AuthErrorOprationNotAllowed extends AuthError {
  const AuthErrorOprationNotAllowed()
      : super(
          dialogTitle: 'Opration not allowed',
          dialogText: 'You cannot register using this mehtod at this moment!',
        );
}

// user-not-found
// when try to login with user not loged in yet
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: 'User not found',
          dialogText: 'The given user was not found on the server!',
        );
}

// auth/weak-password
// when try to register with password very short for example 2 or 3 characters
@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: 'Weak password',
          dialogText:
              'Please choose a stronger password consistiong of more characters',
        );
}

// auth/invalid-email
// when try to login or reiester with invalid email for example the email does not have @ symble
@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: 'Invalid email',
          dialogText: 'Please double check your email and try again!',
        );
}

//auth/email-already-in-use
// when the user try to login with email already exist
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: 'Email already in use',
          dialogText: 'Please choose another email to register with!',
        );
}
