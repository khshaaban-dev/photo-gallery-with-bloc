import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageImageView extends StatelessWidget {
  final Reference imageReference;
  const StorageImageView({
    Key? key,
    required this.imageReference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: imageReference.getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.done:
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Image.memory(
                  data,
                  fit: BoxFit.cover,
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Error While Loading..',
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        });
  }
}
