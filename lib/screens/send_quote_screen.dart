import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/send_quote_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';

class SendQuoteScreen extends StatefulWidget {
  final int? jobId;

  const SendQuoteScreen({Key? key, required this.jobId}) : super(key: key);

  @override
  State<SendQuoteScreen> createState() => _SendQuoteScreenState();
}

class _SendQuoteScreenState extends State<SendQuoteScreen> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isPricePerHour = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CategoryPrice> categoriesAndPrices = [];
  Future<ApiResponse>? futureData;
  late Future<ApiResponse> getFutureData;
  late String getApiUrl;
  var snackbarShown = false;

  @override
  void initState() {
    super.initState();
    getApiUrl =
        '$baseApiUrl/partners/job/get_quote?job_assignment_id=${widget.jobId}';
    getFutureData = GetClient.fetchData(getApiUrl);
    getFutureData.then((response) {
      for (var i = 0; i < response.data.quote.length; i++) {
        var item = response.data.quote[i];
        categoriesAndPrices.add(CategoryPrice(
          category: item.category,
          price: item.price,
          isPricePerHour: item.isPricePerHour,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SendQuoteModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Send Quote'),
        ),
        body: GetRequestFutureBuilder<dynamic>(
          apiUrl: getApiUrl,
          future: getFutureData,
          builder: (context, data) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: AbsorbPointer(
                absorbing: model.isSubmitting,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: form(context, model),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Form form(BuildContext context, SendQuoteModel model) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          formFields(),
          const SizedBox(height: 15),
          addButton(context),
          const SizedBox(height: 15),
          if (categoriesAndPrices.isNotEmpty) ...[
            const SizedBox(height: 10),
            listOfCategories(),
          ],
          if (categoriesAndPrices.isEmpty) ...[
            const Text('No items present'),
          ],
          const SizedBox(height: 15),
          (futureData != null)
              ? PostClient.futureBuilder(
                  model,
                  futureData!,
                  "Send",
                  () async {
                    bool confirm = await CustomAppBar.showConfirmationDialog(
                      context,
                      'Are you sure you want to send the quote? You cannot edit the quote after sending.',
                    );
                    if (confirm) {
                      onSubmitCallback(model);
                    }
                  },
                  () {
                    if (!snackbarShown) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        MySnackBar(
                          message: 'Quote sent successfully',
                          error: false,
                        ).getSnackbar(),
                      );
                      snackbarShown = true;
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(index: 1),
                      ),
                      (route) => false,
                    );
                  },
                )
              : MyForm.submitButton("Send", () async {
                  bool confirm = await CustomAppBar.showConfirmationDialog(
                    context,
                    'Are you sure you want to send the quote? You cannot edit the quote after sending.',
                  );
                  if (confirm) {
                    onSubmitCallback(model);
                  }
                }),
        ],
      ),
    );
  }

  ListView listOfCategories() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categoriesAndPrices.length,
      itemBuilder: (context, index) {
        final categoryPrice = categoriesAndPrices[index];
        return Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              const SizedBox(width: 5),
              SlidableAction(
                onPressed: (context) {
                  categoriesAndPrices
                      .removeWhere((element) => element == categoryPrice);
                  setState(() {});
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            color: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(
                categoryPrice.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${categoryPrice.price.toStringAsFixed(2)}${categoryPrice.isPricePerHour ? " per hour" : ""}",
              ),
            ),
          ),
        );
      },
    );
  }

  ElevatedButton addButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final category = categoryController.text;
          try {
            final price = double.parse(priceController.text);
            categoriesAndPrices.add(
              CategoryPrice(
                category: category,
                price: price,
                isPricePerHour: isPricePerHour,
              ),
            );
            categoryController.clear();
            priceController.clear();
            setState(() {});
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              MySnackBar(
                message: 'Please enter a valid price',
                error: true,
              ).getSnackbar(),
            );
          }
        }
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: const Icon(Icons.add),
    );
  }

  Column formFields() {
    return Column(
      children: [
        MyForm.requiredTextField('Category', categoryController),
        const SizedBox(height: 10),
        MyForm.requiredTextField(
          'Price in pound',
          priceController,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Price Type:',
            ),
            const SizedBox(width: 20),
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
          ],
        ),
      ],
    );
  }

  void onSubmitCallback(SendQuoteModel model) {
    if (categoriesAndPrices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnackBar(
          message: 'Please add at least one category',
          error: true,
        ).getSnackbar(),
      );
    } else if (!model.isSubmitting) {
      model.setIsSubmitting(true);
      snackbarShown = false;
      const String apiUrl = '$baseApiUrl/partners/job/send_quote';
      List<Map<dynamic, dynamic>> data = [];
      for (var e in categoriesAndPrices) {
        var dataHash = {};
        dataHash['category'] = e.category;
        dataHash['price'] = e.price;
        dataHash['is_price_per_hour'] = e.isPricePerHour;

        data.add(dataHash);
      }
      var formData = {'job_assignment_id': widget.jobId, 'data': data};
      futureData = PostClient.request(
        apiUrl,
        formData,
        model,
        (response) async {},
      );
    }
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
