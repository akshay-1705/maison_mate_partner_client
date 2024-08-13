import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/documentation/contract_response.dart';
import 'package:maison_mate/provider/documentation/contract_model.dart';
import 'package:maison_mate/services/verification_status_service.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Contract extends StatefulWidget {
  const Contract({Key? key}) : super(key: key);

  @override
  State<Contract> createState() => _ContractState();
}

class _ContractState extends State<Contract> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  static String apiUrl = '$baseApiUrl/partners/onboarding/contract';
  late Future<ApiResponse> getFutureData;
  Future<ApiResponse>? futureData;

  @override
  void initState() {
    super.initState();
    getFutureData = GetClient.fetchData(apiUrl);
    getFutureData.then((apiResponse) {
      if (mounted) {
        nameController.text = apiResponse.data.signature ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ContractModel model = Provider.of<ContractModel>(context);
    return Scaffold(
        appBar: CustomAppBar.show(
            context, "Contract", const Icon(Icons.arrow_back)),
        body: GetRequestFutureBuilder<dynamic>(
          apiUrl: apiUrl,
          future: getFutureData,
          builder: (context, data) {
            return renderForm(context, data, model);
          },
        ));
  }

  Widget renderForm(
      BuildContext context, ContractResponse data, ContractModel model) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5.0),
      child: WillPopScope(
        onWillPop: () async {
          bool confirm = await CustomAppBar.showConfirmationDialog(
              context, "Are you sure you want to leave this page?");
          if (confirm) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          }
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(children: [
            const SizedBox(height: 10),
            VerificationStatusService.showInfoContainer(data.status ?? '',
                data.reasonForRejection ?? '', 'Contract Details'),
            Form(
              key: _formKey,
              child: AbsorbPointer(
                absorbing: model.isSubmitting,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    MyForm.formFieldHeader(
                      'Your Commitment, Our Commitment.',
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Checkbox(
                            value: model.agree,
                            onChanged: (bool? value) {
                              model.setAgree(value!);
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              String contractUrl = data.document.imageUrl!;
                              final Uri url = Uri.parse(contractUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            child: const Text.rich(
                              TextSpan(
                                text:
                                    'I have read and agree to abide by the terms outlined in ',
                                style: TextStyle(fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: 'the contract.',
                                    style: TextStyle(
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MyForm.formFieldHeader(
                        "Please provide company name/your name you'd like to use as signature on the contract"),
                    MyForm.requiredTextField(
                        "Signature", nameController, false, TextInputType.name),
                    const SizedBox(height: 20),
                    (futureData != null)
                        ? PutClient.futureBuilder(
                            model,
                            futureData!,
                            "Sign",
                            () async {
                              if (model.agree) {
                                String message =
                                    VerificationStatusService.getPromptMessage(
                                        data.status ?? '', 'Contract Details');
                                bool confirm =
                                    await CustomAppBar.showConfirmationDialog(
                                        context, message);
                                if (confirm) {
                                  onSubmitCallback(model);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please agree to the contract by checking the box.')),
                                );
                              }
                            },
                            () {
                              Navigator.of(context).pop();
                            },
                          )
                        : MyForm.submitButton("Sign", () async {
                            if (model.agree) {
                              String message =
                                  VerificationStatusService.getPromptMessage(
                                      data.status ?? '', 'Contract Details');
                              bool confirm =
                                  await CustomAppBar.showConfirmationDialog(
                                      context, message);
                              if (confirm) {
                                onSubmitCallback(model);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree to the contract by checking the box.')),
                              );
                            }
                          }),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void onSubmitCallback(ContractModel model) {
    if (_formKey.currentState!.validate()) {
      model.setIsSubmitting(true);

      var formData = {
        'signature': nameController.text,
      };

      futureData = PutClient.request(apiUrl, formData, model, (response) {});
    }
  }
}
