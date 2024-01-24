import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maison_mate/shared/image_helper.dart';
import 'package:maison_mate/shared/my_snackbar.dart';

File? selectedFile;

class FileUploadService {
  static Widget showWidget(
      BuildContext context, File? file, SuccessCallback setStateCallback) {
    selectedFile = file;
    return Column(children: [
      uploadButton(uploadButtonCallback(context, setStateCallback)),
      if (selectedFile != null) showSelectedImage()
    ]);
  }

  static Widget uploadButton(VoidCallback callback) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () {
          callback();
        },
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload File'),
      ),
    );
  }

  static VoidCallback uploadButtonCallback(
      BuildContext context, SuccessCallback setStateCallback) {
    return () async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Finalising"),
              ],
            ),
          );
        },
      );

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'],
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      if (result != null) {
        const int maxSizeInBytes = 5 * 1024 * 1024;
        if (result.files.single.size <= maxSizeInBytes) {
          selectedFile = File(result.files.single.path!);
          setStateCallback(selectedFile!);
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                    message: 'File size must not exceed 5MB', error: true)
                .getSnackbar());
          });
        }
      }
    };
  }

  static Widget showSelectedImage() {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(
          Icons.insert_drive_file,
          size: 100,
          color: Colors.blue,
        ),
        const SizedBox(height: 5),
        Text(
          selectedFile!.path
              .split('/')
              .last, // You can use file.name to get the file name
          style: const TextStyle(fontSize: 12),
        ),
      ]),
    );
  }
}
