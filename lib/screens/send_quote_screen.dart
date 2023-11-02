import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maison_mate/shared/my_form.dart';

class SendQuoteScreen extends StatefulWidget {
  const SendQuoteScreen({Key? key}) : super(key: key);

  @override
  State<SendQuoteScreen> createState() => _SendQuoteScreenState();
}

class _SendQuoteScreenState extends State<SendQuoteScreen> {
  PageController pageController = PageController(initialPage: 0);
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isPricePerHour = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CategoryPrice> categoriesAndPrices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Send Quote'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyForm.requiredTextField('Category', categoryController),
                      const SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 250,
                              child: MyForm.requiredTextField(
                                  'Price in pound', priceController),
                            ),
                            DropdownButton<bool>(
                              value: isPricePerHour,
                              items: const [
                                DropdownMenuItem<bool>(
                                  value: true,
                                  child: Text("Per Hour"),
                                ),
                                DropdownMenuItem<bool>(
                                  value: false,
                                  child: Text("Total"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  isPricePerHour = value ?? false;
                                });
                              },
                            ),
                          ]),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final category = categoryController.text;
                            final price = double.parse(priceController.text);
                            categoriesAndPrices.add(CategoryPrice(
                              category: category,
                              price: price,
                              isPricePerHour: isPricePerHour,
                            ));
                            categoryController.clear();
                            priceController.clear();
                            setState(() {});
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.shade100,
                          ),
                        ),
                        child: const Icon(Icons.navigate_next),
                      ),
                      const SizedBox(height: 15),
                      if (categoriesAndPrices.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Column(
                          children: categoriesAndPrices.map((categoryPrice) {
                            return Column(
                              children: [
                                Slidable(
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      const SizedBox(width: 5),
                                      SlidableAction(
                                        onPressed: (context) {},
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(categoryPrice.category,
                                        style: const TextStyle(fontSize: 17)),
                                    trailing: Text(
                                        "${categoryPrice.price}${categoryPrice.isPricePerHour ? " per hour" : ""}"),
                                  ),
                                ),
                                const Divider(
                                  height: 10,
                                  color: Colors.grey,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                      if (categoriesAndPrices.isEmpty) ...[
                        const Text('No item present'),
                      ],
                      const SizedBox(height: 15),
                      MyForm.submitButton("Send", () async {}),
                    ],
                  ),
                )))));
  }
}

class CategoryPrice {
  final String category;
  final double price;
  final bool isPricePerHour;

  CategoryPrice({
    required this.category,
    required this.price,
    required this.isPricePerHour,
  });
}
