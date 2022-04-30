import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_galary_with_bloc/auth/auth_error.dart';
import 'package:photo_galary_with_bloc/bloc/app_event.dart';
import 'package:photo_galary_with_bloc/bloc/app_state.dart';
import 'package:photo_galary_with_bloc/uitls/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppStateLoggedOut(
          isLoading: false,
        )) {
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      if (user == null) {
        // if user try to upload image and the user logged out before
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      // loading while uploading the image
      emit(AppStateLoggedIn(
        user: user,
        images: state.images ?? [],
        isLoading: true,
      ));
      //handle uploading image
      final File file = File(event.filePathToUpload);

      final isUpleaded = await uploadImage(
        file: file,
        userId: user.uid,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );

      // handle fialed to upload image
      if (!isUpleaded) {
        // emit error when fail to  image upload
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images!,
            isLoading: false,
            authError: AuthError.from(
              FirebaseAuthException(
                code: 'fialed-to-upload-image',
              ),
            ),
          ),
        );
        return;
      }
      final images = await _getImages(user.uid);

      // get all images form storage
      // return images to the state
      emit(AppStateLoggedIn(
        user: user,
        images: images,
        isLoading: false,
      ));
    });

    on<AppEventDeleteAccount>((event, emit) async {
      final User? user = FirebaseAuth.instance.currentUser;
      // log the user out if we dont have current user
      if (user == null) {
        emit(const AppStateLoggedOut(
          isLoading: false,
        ));
        return;
      }
      // start loading while log out
      emit(AppStateLoggedIn(
        user: user,
        images: state.images ?? [],
        isLoading: true,
      ));
      // delete the user folder
      try {
        // delete the user items ( images )
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          // maybe handle error
          await item.delete().catchError((_) {});
        }
        // delete the user folder it self
        FirebaseStorage.instance.ref(user.uid).delete();

        // delete the user account it self
        await user.delete();

        // sign in the user out
        await FirebaseAuth.instance.signOut();

        //logged out the user in the ui
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: false,
          authError: AuthError.from(e),
        ));
      } on FirebaseException {
        emit(const AppStateLoggedOut(
          isLoading: false,
        ));
      }
    });

    on<AppEventLogOut>((event, emit) async {
      // start loading
      emit(const AppStateLoggedOut(
        isLoading: true,
      ));
      // make log out in firebse
      await FirebaseAuth.instance.signOut();

      // update UI for log out
      emit(const AppStateLoggedOut(
        isLoading: false,
      ));
    });

// when the app start at the beging this event is fires
    on<AppEventInitialize>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(
          isLoading: false,
        ));
      } else {
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      }
    });

    // handle Registration
    on<AppEventRegister>((event, emit) async {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: true,
        ),
      );

      final email = event.email;
      final password = event.password;
      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // the user is register and logged in
        emit(
          AppStateLoggedIn(
            user: userCredential.user!,
            images: const [],
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

// handle when uer move from login to register view
    on<AppEventGoToRegistration>((event, emit) {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: false,
        ),
      );
    });
// handle when uer move from register to login view

    on<AppEventGoToLogIn>((event, emit) {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    on<AppEventLogIn>((event, emit) async {
      // start loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      // handle login opration
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user!;

        //get all images
        final images = await _getImages(user.uid);

        // emit login state
        emit(
          AppStateLoggedIn(
            user: userCredential.user!,
            images: images,
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });
  }

  // helper method for get images from firebase storage
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
