import 'package:flutter/material.dart';

class VerificationStatusService {
  static Widget showInfoContainer(
      String status, String reasonForRejection, String entityName) {
    String textToShow = getInfoText(status, reasonForRejection, entityName);
    Color backgroundColor = getBackgroundColor(status);
    Color textColor = getTextColor(status);

    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: textColor),
          borderRadius: BorderRadius.circular(8.0),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.info,
              color: textColor,
              size: 30,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textToShow,
                    style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  static String getInfoText(
      String status, String reasonForRejection, String entityName) {
    switch (status) {
      case 'submitted':
        return 'We have received your $entityName. Please wait for verification';
      case 'pending':
        return 'Please submit the form below';
      case 'rejected':
        return 'Your $entityName have been rejected. Please resubmit the form with correct details. Reason for rejection: $reasonForRejection';
      case 'verified':
        return 'Your $entityName have been verified';
      default:
        return '';
    }
  }

  static Color getBackgroundColor(String status) {
    switch (status) {
      case 'submitted':
        return Colors.grey.shade100;
      case 'pending':
        return Colors.grey.shade100;
      case 'rejected':
        return const Color(0xffffe6e6);
      case 'verified':
        return const Color(0xffeaf9f4);
      default:
        return Colors.white;
    }
  }

  static Color getTextColor(String status) {
    switch (status) {
      case 'submitted':
        return Colors.grey.shade700;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return const Color(0xffe60000);
      case 'verified':
        return const Color(0xff2dc48b);
      default:
        return Colors.white;
    }
  }

  static String getPromptMessage(String status, String entityName) {
    switch (status) {
      case 'submitted':
        return 'You have already submitted your $entityName. Are you sure you want to submit again?';
      case 'pending':
        return 'Are you sure you want to submit this form?';
      case 'rejected':
        return 'Are you sure you want to submit this form?';
      case 'verified':
        return "Your $entityName have already been verified. Are you sure you want to submit again?\n\nNote: You WON'T be able to find new jobs until we verify your $entityName again.";
      default:
        return '';
    }
  }
}
