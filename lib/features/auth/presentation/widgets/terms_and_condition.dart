import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  TextSpan _buildSectionTitle(String title) {
    return TextSpan(
      text: title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  TextSpan _buildSectionContent(String content) {
    return TextSpan(
      text: content,
      style: const TextStyle(fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black, fontSize: 16),
        children: [
          const TextSpan(
            text: 'Privacy Policy\n\n',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          _buildSectionTitle('Introduction\n'),
          _buildSectionContent(
            'Our privacy policy will help you understand what information we collect at GO Mind Lab, how Go Mind Lab uses it, and what choices you have. Welcome to MindLab, an educational platform developed by Suhail Smart Solutions. These Terms and Conditions outline the rules and regulations for the use of our MindLab app and govern your access to and use of our services..\n\n',
          ),
          _buildSectionTitle('Terms of Use\n'),
          _buildSectionContent(
            'By accessing and using MindLab, you confirm that you have read, understood, and agree to be bound by these Terms. You must not use this app if you disagree with any part of the terms.\n\n',
          ),
          _buildSectionTitle('Changes to Terms\n'),
          _buildSectionContent(
            'We reserve the right to modify these Terms at any time. Changes will become effective immediately upon posting to the app. Your continued use of the app after changes have been posted will constitute your acceptance of those changes.\n\n',
          ),
          _buildSectionTitle('Account Registration and Management\n'),
          _buildSectionContent(
            'Conditions for Account Registration: You must be at least 13 years old to register an account. During registration, you must provide accurate and current information.\n'
            'Account Responsibility: You are responsible for safeguarding the password and all activities that occur under your account.\n'
            'Account Sharing and Security: You agree not to disclose your password to any third party. Notify us immediately upon any unauthorized use of your account or other breaches of security.\n\n',
          ),
          _buildSectionTitle('Acceptable Use\n'),
          _buildSectionContent(
            'You agree not to use MindLab in any manner that:\n\n'
            '• Infringes or violates the intellectual property rights or any other rights of anyone else (including Suhail Smart Solutions).\n'
            '• Violates any law or regulation.\n'
            '• Is harmful, fraudulent, deceptive, threatening, harassing, defamatory, obscene, or otherwise objectionable.\n'
            '• Jeopardizes the security of your MindLab account or anyone else’s.\n'
            '• Attempts to, in any manner, obtain the password, account, or other security information from any other user.\n\n',
          ),
          _buildSectionTitle('Software License\n'),
          _buildSectionContent(
            'MindLab grants you a revocable, non-exclusive, non-transferable, limited license to download, install, and use the app strictly in accordance with the terms of this Agreement.\n\n',
          ),
          _buildSectionContent(
            'We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.\n\n',
          ),
          _buildSectionTitle('Intellectual Property Rights\n'),
          _buildSectionContent(
            'The content, arrangement, and layout of MindLab, including but not limited to, the text, graphics, images, animations, software, and their arrangements, are protected under copyright and other intellectual property laws, and are the property of Suhail Smart Solutions or its licensors.\n\n',
          ),
          _buildSectionTitle('Account Suspension and Termination\n'),
          _buildSectionContent(
            'Conditions for Account Suspension: Your account may be suspended if there is a breach of the terms and conditions, pending an investigation.\n'
            'Account Termination: We may terminate your account if you materially breach the Terms and fail to cure such breach within thirty (30) days from Suhail Smart Solutions’s notice to you thereof.\n'
            'Account Deletion: You may delete your account by using the corresponding functionality directly on the app, and we will facilitate the deletion of your data in accordance with applicable law.\n\n',
          ),
          _buildSectionTitle('Governing Law\n'),
          _buildSectionContent(
            'These Terms shall be governed by and construed in accordance with the laws of United Arab Emirate, and you submit to the non-exclusive jurisdiction of the state and federal courts located in [United Arab Emirate], for the resolution of any disputes.\n\n',
          ),
          _buildSectionTitle('User Content\n'),
          _buildSectionContent(
            'Ownership and Rights: You retain all rights to any content you submit, post, or display on or through MindLab.\n'
            'Licenses to Your Content: By posting content on MindLab, you grant us a non-exclusive, royalty-free, transferable, sublicensable, worldwide license to use, store, display, reproduce, modify, create derivative works, perform, and distribute your content on MindLab solely for the purposes of operating, developing, providing, and using the MindLab app. This license does not grant us the right to sell your content or otherwise distribute it outside of our services.\n\n',
          ),
          _buildSectionTitle('Prohibited Conduct\n'),
          _buildSectionContent(
            'You are solely responsible for your conduct while accessing or using MindLab, and you will not:\n\n'
            '• Engage in any harassing, threatening, intimidating, predatory, or stalking conduct;\n'
            '• Use or attempt to use another user’s account without authorization from that user and Suhail Smart Solutions;\n'
            '• Use MindLab in any manner that could interfere with, disrupt, negatively affect, or inhibit other users from fully enjoying the app, or that could damage, disable, overburden, or impair the functioning of the app in any manner;\n'
            '• Reverse engineer any aspect of MindLab or do anything that might discover source code or bypass or circumvent measures employed to prevent or limit access to any part of MindLab;\n'
            '• Attempt to circumvent any content-filtering techniques we employ or attempt to access any feature or area of MindLab that you are not authorized to access;\n'
            '• Develop or use any third-party applications that interact with MindLab without our prior written consent, including any scripts designed to scrape or extract data from the app.\n\n',
          ),
          _buildSectionTitle('Disclaimers\n'),
          _buildSectionContent(
            'No Warranties: The MindLab app and all included content are provided on an "as is" basis without warranty of any kind, whether express or implied.\n'
            'Disclaimers of Warranties: Suhail Smart Solutions specifically disclaims any and all warranties and conditions of merchantability, fitness for a particular purpose, and non-infringement, and any warranties arising out of course of dealing or usage of trade.\n\n',
          ),
          _buildSectionTitle('Limitation of Liability\n'),
          _buildSectionContent(
            'To the maximum extent permitted by law, Suhail Smart Solutions shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from:\n\n'
            '• Your access to, use of, or inability to access or use MindLab;\n'
            '• Any conduct or content of any third party on MindLab;\n'
            '• Any content obtained from MindLab;\n'
            '• Unauthorized access, use, or alteration of your transmissions or content.\n\n',
          ),
          _buildSectionTitle('Indemnification\n'),
          _buildSectionContent(
            'You agree to indemnify and hold harmless Suhail Smart Solutions and its officers, directors, employees, and agents from any and all claims, demands, losses, liabilities, and expenses (including attorneys\' fees) arising out of or in connection with:\n\n'
            '• Your use of the MindLab app or services or goods obtained through your use of MindLab;\n'
            '• Your breach or violation of any of these Terms;\n'
            '• Suhail Smart Solutions\' use of your User Content; or\n'
            '• Your violation of the rights of any third party, including other users.\n\n',
          ),
          _buildSectionTitle('Arbitration Agreement\n'),
          _buildSectionContent(
            'Agreement to Arbitrate: You and Suhail Smart Solutions agree that any dispute, claim, or controversy between you and Suhail Smart Solutions arising in connection with or relating in any way to these Agreements or to your relationship with Suhail Smart Solutions as a user of MindLab (whether based in contract, tort, statute, fraud, misrepresentation, or any other legal theory, and whether the claims arise during or after the termination of the Agreements) will be determined by mandatory binding individual (not class) arbitration. You and Suhail Smart Solutions further agree that the arbitrator shall have the exclusive power to rule on his or her own jurisdiction, including any objections with respect to the existence, scope, or validity of the Arbitration Agreement or to the arbitrability of any claim or counterclaim.\n'
            'Arbitration Rules: The arbitration will be administered by [Name of Arbitration Association] in accordance with the Commercial Arbitration Rules and the Supplementary Procedures for Consumer Related Disputes (the "Arbitration Rules") then in effect, except as modified by this "Arbitration Agreement".\n'
            'Waiver of Jury Trial: YOU AND SUHAIL SMART SOLUTIONS HEREBY WAIVE ANY CONSTITUTIONAL AND STATUTORY RIGHTS TO SUE IN COURT AND HAVE A TRIAL IN FRONT OF A JUDGE OR A JURY. You and Suhail Smart Solutions are instead electing that all claims and disputes shall be resolved by arbitration under this Arbitration Agreement, except as specified in Section 16.4 "Exceptions to Arbitration" below.\n\n',
          ),
          _buildSectionTitle('Exceptions to Arbitration\n'),
          _buildSectionContent(
            'Small Claims Court: Either you or Suhail Smart Solutions can seek relief in small claims court for disputes or claims within that court’s jurisdiction, as long as it remains an individual claim and does not require class action.\n'
            'Injunctive Relief: As an alternative to arbitration, you or Suhail Smart Solutions may seek injunctive or other equitable relief from any court of competent jurisdiction to prevent the actual or threatened infringement, misappropriation, or violation of a party’s copyrights, trademarks, trade secrets, patents, or other intellectual property rights.\n\n',
          ),
          _buildSectionTitle('Governing Law\n'),
          _buildSectionContent(
            'Jurisdiction: These Terms shall be governed and construed in accordance with the laws of United Arab Emirate, without regard to its conflict of law provisions.\n'
            'Choice of Law: The exclusive jurisdiction and venue for actions related to the subject matter hereof shall be the state and federal courts located in United Arab Emirate and you hereby submit to the personal jurisdiction of such courts.\n\n',
          ),
          _buildSectionTitle('Complete Agreement\n'),
          _buildSectionContent(
            'These Terms constitute the entire agreement between you and Suhail Smart Solutions regarding your use of the app and supersede and replace any prior agreements we might have had between us regarding the app.\n\n',
          ),
          _buildSectionTitle('Contact Us\n'),
          _buildSectionContent(
            'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.\n'
            'Phone: 00971 506 478 587\nEmail: info@gomindlab.com\n',
          ),
        ],
      ),
    );
  }
}
