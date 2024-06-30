import 'package:flutter/material.dart';
import 'states.dart';
import 'package:get/get.dart';
import 'dart:io';

class MultipleImagePicker extends StatefulWidget {
  const MultipleImagePicker({super.key});

  @override
  State<MultipleImagePicker> createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  final _globalStates = Get.find<GlobalStates>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: _globalStates.selectedImagePaths.length,
            itemBuilder: (context, index) {
              return Image.file(
                File(_globalStates.selectedImagePaths[index]),
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _globalStates.selectedImagePaths.clear();
          },
          child: const Text('Clear'),
        ),
      ]),
    );
  }
}
