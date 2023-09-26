import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

Container formFieldHeader(String label) {
  return Container(
      padding: const EdgeInsets.only(left: 10, top: 18, bottom: 18),
      alignment: Alignment.bottomLeft,
      child: Text(
        label,
        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
      ));
}

Opacity requiredTextField(String label, TextEditingController controller,
    [bool? obscure]) {
  obscure ??= false;
  return Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
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

Opacity requiredEmailField(String label, TextEditingController controller) {
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
            } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                .hasMatch(value)) {
              return 'Email is invalid';
            }
            // You can add more specific email format validation here if needed
            return null;
          },
        ),
      ));
}

Opacity disabledTextField(String label, TextEditingController controller) {
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

InputDecoration customInputDecoration(String label) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(15.0), // Adjust the padding
    border: const OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(8.0)), // Adjust the border radius
    ),
    labelText: label,
  );
}

Opacity multilineRequiredTextField(
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

inlineRequiredTextFields(String label1, String label2,
    TextEditingController controller1, TextEditingController controller2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(child: requiredTextField(label1, controller1)),
      Flexible(child: requiredTextField(label2, controller2))
    ],
  );
}

inlineRequiredDisabledTextFields(String label1, String label2,
    TextEditingController controller1, TextEditingController controller2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(child: requiredTextField(label1, controller1)),
      Flexible(child: disabledTextField(label2, controller2))
    ],
  );
}

typedef RadioButtonCallback = void Function(String);

Widget buildRadioButtons(
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

Widget circularLoader() {
  return Container(
    alignment: Alignment.center,
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

typedef MultiSelectFieldCallback = void Function(List<dynamic>);

Container multiSelectField(
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

typedef SubmitButtonCallback = void Function();

Widget submitButton(String buttonText, SubmitButtonCallback onSubmit) {
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
            style: const TextStyle(color: Color(secondaryColor), fontSize: 16)),
      ));
}

Widget buildBulletPoint(String text) {
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

Widget uploadImageButton() {
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
        // Handle image upload here
      },
      icon: const Icon(Icons.upload_file),
      label: const Text('Upload Image'),
    ),
  );
}
