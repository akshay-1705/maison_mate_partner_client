import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:http/http.dart' as http;
import 'package:maison_mate/network/response/image_response.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<void> initialize(
      ImageResponse imageResponse, dynamic model, BuildContext context) async {
    try {
      if (imageResponse.imageUrl != null) {
        final response =
            await http.get(Uri.parse("$baseDomain${imageResponse.imageUrl}"));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/${imageResponse.imageName}');
          await tempFile.writeAsBytes(bytes);
          model.setSelectedFile(tempFile);
        }
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(message: "Unable to load image", error: true)
                .getSnackbar());
      });
    }
  }
}
