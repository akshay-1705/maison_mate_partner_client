// import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/documentation/profile_picture_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';
// import 'package:path_provider/path_provider.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<ApiResponse>? futureData;
  late Future<ApiResponse> getFutureData;
  // static const String apiUrl =
  //     '$baseApiUrl/partners/onboarding/profile_picture';

  // @override
  // void initState() {
  //   super.initState();
  //   getFutureData = GetClient.fetchData(apiUrl);
  //   // var model = Provider.of<ProfilePictureModel>(context, listen: false);
  //   getFutureData.then((apiResponse) async {
  //     if (mounted) {
  //       if (apiResponse.data.profile_picture.isNotEmpty) {
  //         var profilePicture = apiResponse.data.profile_picture;
  //         var filename = apiResponse.data.file_name;
  //         final imageBytes = base64Decode(profilePicture);
  //         final tempDir = await getTemporaryDirectory();
  //         final tempFile = File('${tempDir.path}/$filename');
  //         await tempFile.writeAsBytes(imageBytes);
  //         // model.setSelectedFile(tempFile);
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfilePictureModel(),
        child: Scaffold(
            appBar: CustomAppBar.show(
                context, "Profile picture", const Icon(Icons.arrow_back)),
            body: GetRequestFutureBuilder<dynamic>(
              future: getFutureData,
              builder: (context, data) {
                return renderForm(context);
              },
            )));
  }

  WillPopScope renderForm(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(5.0),
            child: Consumer<ProfilePictureModel>(
                builder: (context, banking, child) {
              final ProfilePictureModel model =
                  Provider.of<ProfilePictureModel>(context);
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    MyForm.formFieldHeader(
                        'Attach a professional picture of yourself. No selfies or group photos; this is the photo customers will see when you book a job.*'),
                    MyForm.uploadImageSection(model),
                    const SizedBox(height: 20),
                    (futureData != null)
                        ? PostClient.futureBuilder(
                            model,
                            futureData!,
                            "Submit",
                            () async {
                              onSubmitCallback(model);
                            },
                            () {},
                          )
                        : MyForm.submitButton("Submit", () async {
                            onSubmitCallback(model);
                          }),
                  ],
                ),
              );
            })),
      ),
    );
  }

  void onSubmitCallback(ProfilePictureModel model) {
    if (_formKey.currentState!.validate()) {
      if (model.selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message: 'Please upload image before submitting', error: true)
            .getSnackbar());
      } else {
        model.setIsSubmitting(true);
        var formData = {
          'file': model.selectedFile,
        };
        // TODO: Update URL
        futureData = PostClient.request('', formData, model, (response) {});
      }
    }
  }
}
