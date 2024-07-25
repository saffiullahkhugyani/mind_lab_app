import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  TextSpan _buildSectionTitle(String title) {
    return TextSpan(
      text: title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  TextSpan _buildSectionContent(String content) {
    return TextSpan(
      text: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 16),
        children: [
          const TextSpan(
            text: 'Privacy Policy\n\n',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          _buildSectionTitle('Introduction\n'),
          _buildSectionContent(
            'Welcome to MindLab, brought to you by Suhail Smart Solutions. Your privacy is paramount to us, and we are committed to protecting it through our compliance with this policy. This document details our policies regarding the collection, use, and disclosure of personal data when you use our app and the choices you have associated with that data.\n\n'
            'Suhail Smart Solutions is dedicated to protecting your privacy and handling any personal information we collect from you with care and respect. This Privacy Policy outlines our practices regarding the collection, use, and disclosure of your information through the MindLab app and informs you about your privacy rights and how the law protects you.\n\n',
          ),
          _buildSectionTitle('Information Collected\n'),
          _buildSectionTitle('Personal Information\n'),
          _buildSectionContent(
            '• Gender: To provide gender-specific educational content and experiences.\n'
            '• Age Group: To tailor educational content to developmental stages and ensure age-appropriate interactions.\n'
            '• Phone Number: Used for account verification, enhancing security, and for critical communications.\n\n',
          ),
          _buildSectionTitle('Usage Data\n'),
          _buildSectionContent(
            'Information on how the MindLab app is accessed and used (e.g., access times, viewed pages) helps us improve functionality and user experience.\n\n',
          ),
          _buildSectionTitle('Purpose of Data Collection\n'),
          _buildSectionContent(
            '• Gender: Ensures content and class setups are culturally appropriate and personalized.\n'
            '• Age Group: Facilitates the delivery of developmentally appropriate educational content.\n'
            '• Phone Number: Critical for securing your account and enabling urgent communications.\n\n',
          ),
          _buildSectionTitle('Data Use\n'),
          _buildSectionContent(
            'The data we collect is essential for operating MindLab and enhancing user experience.\n'
            'We do not sell your personal information to third parties.\n'
            'We may share your data with trusted service providers who assist us with services such as hosting and maintenance, always under strict confidentiality agreements.\n\n',
          ),
          _buildSectionTitle('Data Storage and Security\n'),
          _buildSectionContent(
            'We employ robust security measures to protect your data, including encryption and secure server storage.\n'
            'Personal data is retained only as long as necessary to fulfill the purposes outlined in this policy, unless a longer retention period is mandated by law.\n\n',
          ),
          _buildSectionTitle('User Rights and Controls\n'),
          _buildSectionContent(
            '• Access and Update: You can review and modify your personal information at any time via the app’s settings.\n'
            '• Deletion: You now have the right to request the deletion of your account and associated data, which can be done directly within the app.\n\n',
          ),
          _buildSectionTitle('Protect Your Information\n'),
          _buildSectionContent(
            'We implement a variety of security measures to maintain the safety of your personal information when you enter, submit, or access your personal information. These measures include data encryption, secure servers, and identity verification to prevent unauthorized access.\n\n',
          ),
          _buildSectionTitle('Data Retention\n'),
          _buildSectionContent(
            'We retain your personal information only for as long as is necessary for the purposes set out in this policy, unless a longer retention period is required or permitted by law (such as tax, accounting, or other legal requirements). When we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize it.\n\n',
          ),
          _buildSectionTitle('Data Protection Rights\n'),
          _buildSectionContent(
            'You have certain rights with respect to your personal information, including:\n'
            '• The right to access, update, or delete the information we have on you.\n'
            '• The right of rectification. If you believe your information is inaccurate or incomplete, you have the right to have it corrected.\n'
            '• The right to object. You can object to the processing of your personal information, ask us to restrict processing of your information, or request portability of your information.\n'
            '• The right to withdraw consent. You also have the right to withdraw your consent at any time where we relied on your consent to process your personal information.\n\n',
          ),
          _buildSectionTitle('Types of Data Collected\n'),
          _buildSectionContent(
            'Among the types of Personal Data that MindLab collects, by itself there are: Gender, Age Group, Phone Number, Usage Data, and other types necessary for its operation.\n'
            'Personal Data may be freely provided by the User or, in the case of Usage Data, collected automatically when using MindLab.\n'
            'Unless specified otherwise, all Data requested by MindLab is mandatory and failure to provide this Data may make it impossible for MindLab to provide its services. Users who are uncertain about which Personal Data is mandatory are welcome to contact the Owner.\n\n',
          ),
          _buildSectionTitle('Changes to Privacy Policy\n'),
          _buildSectionContent(
            'We may update our Privacy Policy periodically to reflect changes to our practices or for other operational, legal, or regulatory reasons. Updates will be notified through the new policy on our website and by updating the effective date at the top of this document.\n\n',
          ),
          _buildSectionTitle('Contact Information\n'),
          _buildSectionContent(
            'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.\n'
            'Phone: 00971 506 478 587,\nEmail: info@gomindlab.com\n\n',
          ),
        ],
      ),
    );
  }
}
