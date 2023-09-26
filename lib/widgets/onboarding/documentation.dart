import 'package:flutter/material.dart';
import 'package:maison_mate/states/onboarding.dart';
import 'package:maison_mate/widgets/onboarding/documentation/banking.dart';
import 'package:maison_mate/widgets/onboarding/documentation/company_owner_identification.dart';
import 'package:maison_mate/widgets/onboarding/documentation/employees.dart';
import 'package:maison_mate/widgets/onboarding/documentation/health_and_safety.dart';
import 'package:maison_mate/widgets/onboarding/documentation/insurance.dart';
import 'package:maison_mate/widgets/onboarding/documentation/platform_rules_acceptance.dart';
import 'package:maison_mate/widgets/onboarding/documentation/profile_picture.dart';
import 'package:maison_mate/widgets/onboarding/documentation/selected_services.dart';

class Documentation extends StatefulWidget {
  final Onboarding onboardingModel;
  const Documentation({Key? key, required this.onboardingModel})
      : super(key: key);

  @override
  State<Documentation> createState() => _DocumentationState();
}

class _DocumentationState extends State<Documentation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const status = 'Pending';
    Color color = getColor(status);
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: ListView.separated(
          itemCount: documentationParts.length,
          separatorBuilder: (context, index) => const Divider(
            height: 10,
            color: Colors.grey,
          ),
          itemBuilder: (context, index) {
            final part = documentationParts[index];
            return ListTile(
              title: Text(part.title, style: const TextStyle(fontSize: 17)),
              subtitle:
                  Text(status, style: TextStyle(fontSize: 11, color: color)),
              trailing: getIcon(status, color),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => part.page,
                  ),
                );
              },
            );
          },
        ),
      ),
    ]));
  }

  Icon getIcon(String status, Color color) {
    switch (status) {
      case 'Completed':
        return Icon(Icons.check_circle, color: color);
      case 'Pending':
        return Icon(Icons.pending_actions, color: color);
      case 'Failed':
        return Icon(Icons.error, color: color);
      default:
        return Icon(Icons.help, color: color);
    }
  }

  Color getColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class DocumentationPart {
  final String title;
  final Widget page;

  DocumentationPart({required this.title, required this.page});
}

List<DocumentationPart> documentationParts = [
  DocumentationPart(
    title: 'Banking',
    page: const Banking(),
  ),
  DocumentationPart(
    title: 'Insurance',
    page: const Insurance(),
  ),
  DocumentationPart(
    title: 'Company owner identification',
    page: const CompanyOwnerIdentification(),
  ),
  DocumentationPart(
    title: 'Employees',
    page: const Employees(),
  ),
  DocumentationPart(
    title: 'Profile picture',
    page: const ProfilePicture(),
  ),
  DocumentationPart(
    title: 'Health and safety',
    page: const HealthAndSafety(),
  ),
  DocumentationPart(
    title: 'Selected services',
    page: const SelectedServices(),
  ),
  DocumentationPart(
    title: 'Platform rules acceptance',
    page: const PlatformRulesAcceptance(),
  ),
];
