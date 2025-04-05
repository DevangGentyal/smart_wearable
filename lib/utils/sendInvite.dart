import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> loadEmailTemplate() async {
  try {
    return await rootBundle.loadString('assets/mail_template.html');
  } catch (e) {
    print('Error loading email template: $e');
    throw 'Template file not found!';
  }
}

Future<bool> sendInvite(
    String recipientEmail, String patientName, String inviteLink) async {
  // await dotenv.load();
  String your_email = 'draxgentyal02@gmail.com';
  String your_password = 'turt osuw qybv kyty'; // Use an App Password

  final smtpServer = gmail(your_email, your_password);

  // Load HTML template
  String htmlTemplate = await loadEmailTemplate();

  // Replace placeholders with actual values
  htmlTemplate = htmlTemplate.replaceAll('{{username}}', patientName);
  htmlTemplate = htmlTemplate.replaceAll('{{verify_link}}', inviteLink);

  final message = Message()
    ..from = Address(your_email, 'Smart Wearable')
    ..recipients.add(recipientEmail)
    ..subject = "Guardian Invitation for $patientName"
    ..html = htmlTemplate;

  try {
    await send(message, smtpServer);
    print('Email sent successfully!');
    return true;
  } catch (e) {
    throw 'Failed to Send Invite to Guardian';
  }
}
