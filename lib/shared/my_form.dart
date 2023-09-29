import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MyForm {
  static Container formFieldHeader(String label, [Color? color]) {
    color ??= Colors.black;
    return Container(
        padding: const EdgeInsets.only(left: 10, top: 18, bottom: 18),
        alignment: Alignment.bottomLeft,
        child: Text(
          label,
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.w500, color: color),
        ));
  }

  static Opacity requiredTextField(
      String label, TextEditingController controller,
      [bool? obscure, TextInputType? keyboardType]) {
    keyboardType ??= TextInputType.text;
    obscure ??= false;
    return Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            decoration: customInputDecoration(label),
            validator: (value) {
              if ((value == null || value.isEmpty)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ));
  }

  static Opacity requiredEmailField(
      String label, TextEditingController controller) {
    return Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: TextFormField(
            controller: controller,
            decoration: customInputDecoration(label),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              } else if (!RegExp(
                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                  .hasMatch(value)) {
                return 'Email is invalid';
              }
              // You can add more specific email format validation here if needed
              return null;
            },
          ),
        ));
  }

  static Opacity disabledTextField(
      String label, TextEditingController controller) {
    return Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: TextFormField(
            enabled: false,
            controller: controller,
            decoration: customInputDecoration(label),
            validator: (value) {
              if ((value == null || value.isEmpty)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ));
  }

  static InputDecoration customInputDecoration(String label) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(15.0), // Adjust the padding
      border: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(8.0)), // Adjust the border radius
      ),
      labelText: label,
    );
  }

  static Opacity multilineRequiredTextField(
      String label, TextEditingController controller) {
    return Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: controller,
            minLines: 2,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            decoration: customInputDecoration(label),
            validator: (value) {
              if ((value == null || value.isEmpty)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ));
  }

  static inlineRequiredTextFields(String label1, String label2,
      TextEditingController controller1, TextEditingController controller2,
      [TextInputType? keyboardType1, TextInputType? keyboardType2]) {
    keyboardType1 ??= TextInputType.text;
    keyboardType2 ??= TextInputType.text;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
            child:
                requiredTextField(label1, controller1, false, keyboardType1)),
        Flexible(
            child: requiredTextField(label2, controller2, false, keyboardType2))
      ],
    );
  }

  static inlineRequiredDisabledTextFields(String label1, String label2,
      TextEditingController controller1, TextEditingController controller2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(child: requiredTextField(label1, controller1)),
        Flexible(child: disabledTextField(label2, controller2))
      ],
    );
  }

  static Widget buildRadioButtons(
    List<String> options,
    String selectedValue,
    RadioButtonCallback onValueChanged,
  ) {
    return Column(
      children: options.map((option) {
        return Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: selectedValue,
              onChanged: (value) {
                onValueChanged(value!);
              },
            ),
            Text(option),
          ],
        );
      }).toList(),
    );
  }

  static Widget circularLoader() {
    return Container(
      alignment: Alignment.center,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Container multiSelectField(
      List<MultiSelectItem> items,
      Text title,
      String buttonLabel,
      MultiSelectFieldCallback onConfirm,
      IconData icon,
      List<String> initialItems) {
    return Container(
        padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
        child: MultiSelectDialogField(
          items: items,
          title: title,
          searchable: true,
          initialValue: initialItems,
          selectedColor: const Color(themeColor),
          validator: (value) {
            if ((value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
          decoration: BoxDecoration(
            color: const Color(secondaryColor).withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          buttonIcon: Icon(
            icon,
            color: const Color(awesomeColor),
          ),
          buttonText: Text(
            buttonLabel,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          onConfirm: (results) {
            onConfirm(results);
          },
        ));
  }

  static Widget submitButton(String buttonText, SubmitButtonCallback onSubmit) {
    return SizedBox(
        width: 125,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            onSubmit();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Color(themeColor)),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(themeColor),
            ),
          ),
          child: Text(buttonText,
              style:
                  const TextStyle(color: Color(secondaryColor), fontSize: 16)),
        ));
  }

  static Widget buildBulletPoint(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.circle, size: 9),
        const SizedBox(width: 10),
        Baseline(
          baseline: 10.0,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  static Widget uploadImageSection(dynamic model) {
    return Column(children: [
      uploadImageButton(model),
      if (model.fileName.isNotEmpty)
        Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text(model.fileName))
    ]);
  }

  static Widget uploadImageButton(dynamic model) {
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
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image,
          );
          if (result != null) {
            model.setSelectedFile(File(result.files.single.path!));
          }
        },
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Image'),
      ),
    );
  }

  static Widget checkbox(String textLabel, bool value) {
    return CheckboxListTile(
      title: Text(textLabel, style: const TextStyle(fontSize: 12)),
      value: value,
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      onChanged: (newValue) {
        // setState(() {
        //   // checkbox3Value = newValue!;
        // });
      },
    );
  }

  static Widget datePickerFormField(String label,
      TextEditingController controller, BuildContext context, dynamic model) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: TextFormField(
          readOnly: true, // Make the field read-only
          controller: controller,
          decoration: customInputDecoration(label),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: const Color(themeColor), // Your theme color
                    hintColor: const Color(themeColor), // Your theme color
                    colorScheme: const ColorScheme.light(
                      primary: Color(themeColor), // Your theme color
                    ),
                    buttonTheme: const ButtonThemeData(
                        textTheme: ButtonTextTheme.primary),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null && pickedDate != DateTime.now()) {
              controller.text = pickedDate.toString();
              model.epochString = pickedDate.millisecondsSinceEpoch.toString();
            }
          },
        ),
      ),
    );
  }
}

typedef RadioButtonCallback = void Function(String);
typedef MultiSelectFieldCallback = void Function(List<dynamic>);
typedef SubmitButtonCallback = void Function();
