import 'package:flutter/material.dart';
import 'package:maison_mate/constants.dart';
import 'package:maison_mate/network/client/get_client.dart';
import 'package:maison_mate/network/client/put_client.dart';
import 'package:maison_mate/network/response/api_response.dart';
import 'package:maison_mate/network/response/documentation/documentation_response.dart';
import 'package:maison_mate/provider/documentation_model.dart';
import 'package:maison_mate/screens/home_screen.dart';
import 'package:maison_mate/services/verification_status_service.dart';
import 'package:maison_mate/shared/custom_app_bar.dart';
import 'package:maison_mate/shared/my_form.dart';
import 'package:maison_mate/shared/my_snackbar.dart';
import 'package:maison_mate/widgets/onboarding/documentation/banking.dart';
import 'package:maison_mate/widgets/onboarding/documentation/contract.dart';
import 'package:maison_mate/widgets/onboarding/documentation/employees.dart';
import 'package:maison_mate/widgets/onboarding/documentation/health_and_safety.dart';
import 'package:maison_mate/widgets/onboarding/documentation/insurance.dart';
import 'package:maison_mate/widgets/onboarding/documentation/owner_identification.dart';
import 'package:maison_mate/widgets/onboarding/documentation/profile_picture.dart';
import 'package:provider/provider.dart';

class Documentation extends StatefulWidget {
  const Documentation({Key? key}) : super(key: key);

  @override
  State<Documentation> createState() => _DocumentationState();
}

class _DocumentationState extends State<Documentation> {
  late Future<ApiResponse> getFutureData;
  Future<ApiResponse>? futureData;
  static String apiUrl = '$baseApiUrl/partners/onboarding/documentation';

  @override
  void initState() {
    super.initState();
    getFutureData = GetClient.fetchData(apiUrl);
    getFutureData.then((apiResponse) {
      if (mounted) {
        var stateModel =
            Provider.of<DocumentationModel>(context, listen: false);

        stateModel.canWorkInUK = apiResponse.data.canWorkInUk;
        stateModel.agree = apiResponse.data.agreeToTnc;
        stateModel.notHaveCriminalOffence =
            apiResponse.data.notHaveCriminalOffence;
      }
    });
  }

  Future<void> refreshData() async {
    final response = await GetClient.fetchData(apiUrl);
    setState(() {
      getFutureData = Future.value(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DocumentationModel model = Provider.of<DocumentationModel>(context);
    model.pendingDocuments = false;

    return Scaffold(
        body: GetRequestFutureBuilder<dynamic>(
      apiUrl: apiUrl,
      future: getFutureData,
      builder: (context, data) {
        return renderForm(model, data, context);
      },
    ));
  }

  SingleChildScrollView renderForm(DocumentationModel model,
      DocumentationResponse data, BuildContext context) {
    if (['pending', 'rejected'].contains(data.sectionWiseStatus.personal)) {
      model.pendingDocuments = true;
    }
    bool limited = data.isLimited;
    List<DocumentationPart> documentationParts = [
      DocumentationPart(
          title: 'Banking',
          page: const Banking(),
          status: data.sectionWiseStatus.banking ?? 'pending',
          hide: false),
      DocumentationPart(
          title: 'Insurance',
          page: const Insurance(),
          status: data.sectionWiseStatus.insurance ?? 'pending',
          hide: data.hideInsurance),
      DocumentationPart(
          title: 'Owner identification',
          page: OwnerIdentification(limited: limited),
          status: data.sectionWiseStatus.ownerIdentification ?? 'pending',
          hide: false),
      DocumentationPart(
          title: 'Employees',
          page: const Employees(),
          status: data.sectionWiseStatus.employees ?? 'pending',
          hide: false),
      DocumentationPart(
          title: 'Profile picture',
          page: const ProfilePicture(),
          status: data.sectionWiseStatus.profilePicture ?? 'pending',
          hide: false),
      DocumentationPart(
          title: 'Health and safety',
          page: const HealthAndSafety(),
          status: data.sectionWiseStatus.healthAndSafety ?? 'pending',
          hide: !limited),
      DocumentationPart(
          title: 'Contract',
          page: const Contract(),
          status: data.sectionWiseStatus.contract ?? 'pending',
          hide: data.hideContract),
    ];

    return SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Consumer<DocumentationModel>(builder: (context, banking, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children:
                    documentationParts.where((part) => !part.hide).map((part) {
                  Icon icon = getIcon(part.status, model);
                  return Column(
                    children: [
                      ListTile(
                        title: Text(part.title,
                            style: const TextStyle(fontSize: 17)),
                        trailing: icon,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => part.page,
                            ),
                          );
                          refreshData();
                        },
                      ),
                      const Divider(
                        height: 10,
                        color: Colors.grey,
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              MyForm.checkbox(
                  'Have the right to work in the UK', model.canWorkInUK,
                  (value) {
                model.setCanWorkInUK(value);
              }),
              MyForm.checkbox(
                  'Do not have any criminal offences which are currently unspent under the Rehabilitation of Offenders Act 1974',
                  model.notHaveCriminalOffence, (value) {
                model.setNotHaveCriminalOffence(value);
              }),
              MyForm.checkbox(
                  'Agree to the Maison Mate, Terms of Use, Commercial Terms and Code of Conduct, and that you will follow the processes set out within them',
                  model.agree, (value) {
                model.setAgree(value);
              }),
              const SizedBox(height: 20),
              (futureData != null)
                  ? PutClient.futureBuilder(
                      model,
                      futureData!,
                      "Final submit",
                      () async {
                        String message =
                            VerificationStatusService.getPromptMessage(
                                data.onboardingStatus ?? '',
                                'Documentation Details');
                        bool confirm =
                            await CustomAppBar.showConfirmationDialog(
                                context, message);
                        if (confirm) {
                          onSubmitCallback(model);
                        }
                      },
                      () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                    )
                  : MyForm.submitButton("Final submit", () async {
                      String message =
                          VerificationStatusService.getPromptMessage(
                              data.onboardingStatus ?? '', 'details');
                      bool confirm = await CustomAppBar.showConfirmationDialog(
                          context, message);
                      if (confirm) {
                        onSubmitCallback(model);
                      }
                    }),
              const SizedBox(height: 50),
            ],
          );
        }));
  }

  void onSubmitCallback(DocumentationModel model) {
    if (!model.pendingDocuments) {
      if (model.agree && model.canWorkInUK && model.notHaveCriminalOffence) {
        model.setIsSubmitting(true);
        var formData = {
          'agree_to_tnc': model.agree.toString(),
          'can_work_in_uk': model.canWorkInUK.toString(),
          'not_have_criminal_offence': model.notHaveCriminalOffence.toString(),
        };
        futureData = PutClient.request(apiUrl, formData, model, (response) {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
                message:
                    'Please review and agree to all policies before submitting',
                error: true)
            .getSnackbar());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
              message:
                  'Please complete all the pending steps before submitting',
              error: true)
          .getSnackbar());
    }
  }

  Icon getIcon(String status, DocumentationModel model) {
    switch (status) {
      case 'verified':
        return const Icon(Icons.verified, color: Colors.green);
      case 'submitted':
        return const Icon(Icons.verified, color: Colors.grey);
      case 'pending':
        model.pendingDocuments = true;
        return const Icon(Icons.pending_actions_rounded, color: Colors.orange);
      case 'rejected':
        model.pendingDocuments = true;
        return const Icon(Icons.error, color: Colors.red);
      default:
        model.pendingDocuments = true;
        return const Icon(Icons.help, color: Colors.orange);
    }
  }
}

class DocumentationPart {
  final String title;
  final Widget page;
  final String status;
  final bool hide;

  DocumentationPart(
      {required this.title,
      required this.page,
      required this.status,
      required this.hide});
}
