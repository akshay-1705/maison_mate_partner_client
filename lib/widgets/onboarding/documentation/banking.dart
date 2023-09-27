import 'package:flutter/material.dart';
import 'package:maison_mate/network/client/post_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/provider/documentation/banking_model.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:provider/provider.dart';

class Banking extends StatefulWidget {
  const Banking({Key? key}) : super(key: key);

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<ApiResponse>? futureData;
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController sortCodeController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BankingModel(),
        child: Scaffold(
          appBar: CustomAppBar.show(
              context, "Banking", const Icon(Icons.arrow_back)),
          body: WillPopScope(
            onWillPop: () async {
              return Future.value(false);
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(5.0),
                  child: Consumer<BankingModel>(
                      builder: (context, banking, child) {
                    final BankingModel model =
                        Provider.of<BankingModel>(context);
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          MyForm.formFieldHeader('Bank Details'),
                          MyForm.inlineRequiredTextFields(
                            'Bank Name*',
                            'Sort code*',
                            bankNameController,
                            sortCodeController,
                          ),
                          MyForm.requiredTextField(
                              "Account Number*", accountNumberController),
                          const SizedBox(height: 25),
                          MyForm.formFieldHeader(
                            'Attach a photo of your bank proof. This can include any of the following*:',
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyForm.buildBulletPoint(
                                    'Top-half of bank statement'),
                                const SizedBox(height: 10),
                                MyForm.buildBulletPoint('Paying-in slip'),
                                const SizedBox(height: 10),
                                MyForm.buildBulletPoint(
                                    'Screenshot of mobile banking'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
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
          ),
        ));
  }

  void onSubmitCallback(BankingModel model) {
    if (_formKey.currentState!.validate()) {
      if (model.selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message: 'Please upload image before submitting', error: true)
            .getSnackbar());
      } else {
        model.setIsSubmitting(true);
        var formData = {
          'bank_name': bankNameController.text,
          'sort_code': sortCodeController.text,
          'account_number': accountNumberController.text,
          'file': model.selectedFile,
        };
        // TODO: Update URL
        futureData = PostClient.request('', formData, model, (response) {});
      }
    }
  }
}
