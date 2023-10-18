import 'package:flutter/material.dart';
import 'package:maison_mate/shared/my_form.dart';

class AreaCoveredScreen extends StatefulWidget {
  const AreaCoveredScreen({Key? key}) : super(key: key);

  @override
  State<AreaCoveredScreen> createState() => _AreaCoveredScreenState();
}

class _AreaCoveredScreenState extends State<AreaCoveredScreen> {
  double _selectedRadius = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 200),
            const Text(
              'You will receive jobs within the selected service radius only.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(
              'Service Radius: ${_selectedRadius.toStringAsFixed(0)} miles',
              style: const TextStyle(fontSize: 20),
            ),
            Slider(
              value: _selectedRadius,
              onChanged: (value) {
                setState(() {
                  _selectedRadius = value;
                });
              },
              min: 5,
              max: 100,
              divisions: 10,
              label: _selectedRadius.toStringAsFixed(0),
              activeColor: Colors.green, // Change the slider color
            ),
            const SizedBox(height: 20),
            MyForm.submitButton("Submit", () async {}),
          ],
        ),
      ),
    );
  }
}
