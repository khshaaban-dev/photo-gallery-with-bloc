import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_galary_with_bloc/bloc/app_event.dart';
import 'package:photo_galary_with_bloc/bloc/app_state.dart';
import 'package:photo_galary_with_bloc/views/main_bopup_menu.dart';
import 'package:photo_galary_with_bloc/views/storage_image_view.dart';

import '../bloc/app_bloc.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // save picker for one time in useMemoized to avoid recreation every rebuild.
    final picker = useMemoized(
      () => ImagePicker(),
      [key],
    );

    // watch images from bloc state and rebuild widget every change .
    final imagesReferences = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) {
                return;
              }
              context.read<AppBloc>().add(
                    AppEventUploadImage(
                      filePathToUpload: image.path,
                    ),
                  );
            },
            icon: const Icon(
              Icons.upload,
            ),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 2,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        children: imagesReferences
            .map(
              (image) => StorageImageView(
                imageReference: image,
              ),
            )
            .toList(),
      ),
    );
  }
}
