import 'package:flutter/material.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';

class SelectedServices extends StatefulWidget {
  const SelectedServices({Key? key}) : super(key: key);

  @override
  State<SelectedServices> createState() => _SelectedServicesState();
}

class _SelectedServicesState extends State<SelectedServices> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.show(
            context, "Selected services", const Icon(Icons.arrow_back)),
        body: WillPopScope(
            onWillPop: () async {
              return Future.value(false);
            },
            child: SingleChildScrollView(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Form(
                        key: _formKey,
                        child: const AbsorbPointer(
                            absorbing: false,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [])))))));
  }
}
