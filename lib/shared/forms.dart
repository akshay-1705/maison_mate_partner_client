import 'package:flutter/material.dart';

Container formFieldHeader(String label) {
  return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.bottomLeft,
      child: Text(
        label,
        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
      ));
}

Opacity requiredTextField(String label, TextEditingController controller) {
  return Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: TextFormField(
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
