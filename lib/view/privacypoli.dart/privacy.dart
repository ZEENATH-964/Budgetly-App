import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Appcolors.whitecolors),
        backgroundColor: const Color(0XFF0008B4),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Appcolors.whitecolors,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<Datacontroller>(
        builder: (context, value, child) {
          return CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFF0008B4),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Column(
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your Privacy Matters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Last updated: ${DateTime.now().year}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Section
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Introduction Card
                    _buildCard(
                      icon: Icons.info_outline,
                      iconColor: Colors.blue,
                      title: 'Introduction',
                      content:
                          'We value your privacy. Our app collects basic information such as your name and email address for login and personalization purposes.',
                    ),
                    SizedBox(height: 16),

                    // Data Usage Card
                    _buildCard(
                      icon: Icons.data_usage,
                      iconColor: Colors.green,
                      title: 'Data Usage',
                      content: null,
                      children: [
                        _buildBulletPoint('To improve app functionality'),
                        _buildBulletPoint('To personalize your experience'),
                        _buildBulletPoint('For analytics and crash reporting'),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Data Sharing Card
                    _buildCard(
                      icon: Icons.share,
                      iconColor: Colors.orange,
                      title: 'Data Sharing',
                      content:
                          'We do not share your personal data with any third parties except for services like Firebase Authentication, which we use to manage user accounts.',
                    ),
                    SizedBox(height: 16),

                    // Security Card
                    _buildCard(
                      icon: Icons.security,
                      iconColor: Colors.red,
                      title: 'Security',
                      content:
                          'We use secure technologies and encryption to protect your data.',
                    ),
                    SizedBox(height: 16),

                    // User Rights Card
                    _buildCard(
                      icon: Icons.person_outline,
                      iconColor: Colors.purple,
                      title: 'User Rights',
                      content:
                          'You may contact us at any time to request data deletion or updates.',
                    ),
                    SizedBox(height: 16),

                    // Updates Card
                    _buildCard(
                      icon: Icons.update,
                      iconColor: Colors.teal,
                      title: 'Updates',
                      content:
                          'We may update our privacy policy. Changes will be notified through the app.',
                    ),
                    SizedBox(height: 24),

                    // Contact Section
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0XFF0008B4),
                            Color(0XFF0008B4).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0XFF0008B4).withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            value.launchURL(
                              "mailto:mubashirtc54@gmail.com?subject=Budgetly Support Request&body=Hi Team Budgetly,",
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Have Questions?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Contact Us',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  Appstring.email,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? content,
    List<Widget>? children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            if (content != null) ...[
              SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
            if (children != null) ...[
              SizedBox(height: 16),
              ...children,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
